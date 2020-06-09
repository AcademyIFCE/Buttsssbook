//
//  Chat.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 21/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

class Chat: NSObject {
    
    static var `default` = Chat(socketURL: URL(string: "ws://localhost:8080/chat")!)
    
    private var request: URLRequest!
    private var task: URLSessionWebSocketTask!
    
    private (set) var isConnected: Bool = false
    
    private var callback: Service.Handler<Message>?
    
    init(socketURL: URL) {
        super.init()
        self.request = URLRequest(url: socketURL)
    }
    
    func connect(authentication: HTTPAuthentication) {
        guard !isConnected else { return }
        request.addValue(authentication.value, forHTTPHeaderField: "Authorization")
        self.task = URLSession(configuration: .default, delegate: self, delegateQueue: nil).webSocketTask(with: request)
        self.task.resume()
        self.receive()
    }
    
    func disconnect() {
        self.task.cancel()
    }
    
    func onReceive(callback: @escaping Service.Handler<Message>) {
        self.callback = callback
    }
    
    func send(_ message: String, completion: @escaping (Error?)->Void) {
        task.send(.string(message), completionHandler: completion)
    }
    
    private func receive() {
        self.task.receive { [unowned self] (result) in
            defer {
                if self.task.closeCode == .invalid { self.receive() }
            }
            self.callback?(self.handle(result))
        }
    }
    
    private func handle(_ result: Result<URLSessionWebSocketTask.Message, Error>) -> Result<Message, Service.Error> {
        do {
            let message = try result.get()
            switch message {
            case .data(let data):
                do {
                    return .success(try JSONDecoder().decode(Message.self, from: data))
                }
                catch {
                    return .failure(.decoding(error, data))
                }
            default:
                return .failure(.abort("wrong message format"))
            }
        }
        catch let error {
            return .failure(.network(error))
        }
    }
    
}

extension Chat: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.isConnected = true
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print(#function)
    }
    
}

/*
 
 MARK: Guiding Resources
 
 https://appspector.com/blog/websockets-in-ios-using-urlsessionwebsockettask
 https://ohmyswift.com/blog/2019/08/31/introducing-urlsessionwebsockettask-native-websocket-implementation-using-swift-5/
 
*/
