//
//  Service+Endpoint.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 01/06/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

extension Service {
    
    enum Endpoint: HTTPEndpoint {
        
        case signUp(name: String, email: String, avatar: String, password: String)
        case signIn(email: String, password: String)
        case signOut(token: String)
        case changeAvatar(token: String, avatar: String)
        case createPost(token: String, post: Post.Input)
        case allPosts
        
        var path: String {
            switch self {
            case .signUp:
                return "users"
            case .signIn:
                return "users/login"
            case .signOut:
                return "users/logout"
            case .changeAvatar:
                return "users/avatar"
            case .createPost:
                return "posts/form"
            case .allPosts:
                return "posts"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .signUp:
                return .post
            case .signIn:
                return .post
            case .signOut:
                return .post
            case .changeAvatar:
                return .patch
            case .createPost:
                return .post
            case .allPosts:
                return .get
            }
        }
        
        var body: HTTPBody? {
            switch self {
            case .signUp(let name, let email, let avatar, let password):
                let user = ["name": name, "email": email, "avatar": avatar, "password": password]
                let data = try! JSONSerialization.data(withJSONObject: user)
                return .init(data: data, contentType: "application/json")
            case .signIn:
                return nil
            case .signOut:
                return nil
            case .changeAvatar(_, let avatar):
                return .init(data: try! JSONEncoder().encode(avatar), contentType: "application/json")
            case .createPost(_, let post):
                var form = HTTPMultipartFormData()
                form["content"] = .text(post.content)
                form["image"] = post.image?.pngData().map { .file(data: $0, name: "image.png", mimeType: "image/png") }
                return .init(data: form.data(), contentType: "multipart/form-data; boundary=\(form.boundary)")
            case .allPosts:
                return nil
            }
        }
        
        var authentication: HTTPAuthentication? {
            switch self {
            case .signUp:
                return nil
            case .signIn(let email, let password):
                return .basic(username: email, password: password)
            case .signOut(let token):
                return .bearer(token: token)
            case .changeAvatar(let token, _):
                return .bearer(token: token)
            case .createPost(let token, _):
                return .bearer(token: token)
            case .allPosts:
                return nil
            }
        }
        
        func request(baseURL: URL) -> URLRequest {
            var request = URLRequest(url: baseURL.appendingPathComponent(path))
            request.httpMethod = method.rawValue
            body.map {
                request.httpBody = $0.data
                request.addValue($0.contentType, forHTTPHeaderField: "Content-Type")
            }
            authentication.map {
                request.addValue($0.value, forHTTPHeaderField: "Authorization")
            }
            return request
        }
    
    }
    
}

/*
 
MARK: Guiding Resources

https://medium.com/swlh/modeling-rest-endpoints-with-enums-in-swift-18965f30ee94

*/
