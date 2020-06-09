//
//  ChatController.swift
//  App
//
//  Created by Mateus Rodrigues on 21/05/20.
//

import Vapor

class ChatController: RouteCollection {
    
    private var connections = Set<Connection>()
    
    func boot(routes: RoutesBuilder) throws {
        routes.group(Token.authenticator()) {
            $0.webSocket("chat", onUpgrade: onUpgrade)
        }
    }
    
    func onUpgrade(request: Request, socket: WebSocket) {
        guard let user = try? request.auth.require(User.self) else {
            socket.close(promise: nil)
            return
        }
        
        let connection = Connection(user: user.public, socket: socket)
        
        connections.insert(connection)
        
        socket.onText { (ws, text) in
            do {
                try self.dispatch(text, from: connection)
            } catch {
                print(error)
            }
        }
        
    }
    
    func dispatch(_ text: String, from connection: Connection) throws {
        let message = Message(user: connection.user, text: text)
        let data = try JSONEncoder().encode(message)
        connections.forEach {
            $0.socket.send([UInt8](data))
        }
    }
    
}
