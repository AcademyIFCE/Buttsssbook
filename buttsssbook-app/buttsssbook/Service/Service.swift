//
//  Server.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 10/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import Combine

class Service {
    
    typealias Handler<T> = (Result<T, Service.Error>) -> Void
    
    static var `default` = Service(baseURL: URL(string: "http://localhost:8080")!)
    
    let baseURL: URL

    var session: Session {
        return Storage.session!
    }
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func signUp(name: String, email: String, avatar: String, password: String, completion: @escaping Handler<Session>) {
        self.call(to: .signUp(name: name, email: email, avatar: avatar, password: password), completion: completion)
    }
    
    func signIn(email: String, password: String, completion: @escaping Handler<Session>) {
        self.call(to: .signIn(email: email, password: password), completion: completion)
    }
    
    func signOut(completion: @escaping Handler<Session>) {
        self.call(to: .signOut(token: session.token), completion: completion)
    }
    
    func change(avatar: String, completion: @escaping Handler<User>) {
        self.call(to: .changeAvatar(token: session.token, avatar: avatar), completion: completion)
    }
    
    func create(_ post: Post.Input, completion: @escaping Handler<Post>) {
        self.call(to: .createPost(token: session.token, post: post), completion: completion)
    }
    
    func fetch(completion: @escaping Handler<[Post]>) {
        self.call(to: .allPosts, completion: completion)
    }
    
    func call<T: Codable>(to endpoint: Endpoint, completion: @escaping Handler<T>) {
        let task = URLSession.shared.dataTask(with: endpoint.request(baseURL: baseURL)) {
            completion(self.result(data: $0, response: $1, error: $2))
        }
        task.resume()
    }
    
    func call<T: Codable>(to endpoint: Endpoint, decoding: T.Type, completion: @escaping Handler<T>) {
        let task = URLSession.shared.dataTask(with: endpoint.request(baseURL: baseURL)) {
            completion(self.result(data: $0, response: $1, error: $2))
        }
        task.resume()
    }
    
    private func result<T: Codable>(data: Data?, response: URLResponse?, error: Swift.Error?) -> Result<T, Error> {
        if let data = data {
            if let error = try? JSONDecoder().decode(Abort.self, from: data) {
                return .failure(.abort(error.reason))
            }
            do {
                return .success(try JSONDecoder().decode(T.self, from: data))
            } catch let error {
                return .failure(.decoding(error, data))
            }
        }
        else if let error = error {
            return .failure(.network(error))
        }
        else {
            return .failure(.unknown(data, response))
        }
    }
    
}

/*
 
MARK: Guiding Resources

https://www.swiftbysundell.com/articles/the-power-of-result-types-in-swift/
https://www.avanderlee.com/swift/typealias-usage-swift/

*/
