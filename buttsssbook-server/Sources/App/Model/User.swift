//
//  User.swift
//  App
//
//  Created by Mateus Rodrigues on 03/05/20.
//

import Vapor
import Fluent

final class User: Model {

    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "avatar")
    var avatar: String
    
    @Field(key: "password")
    var password: String
    
    @Children(for: \.$user)
    var posts: [Post]
    
    init() { }
    
    init(id: UUID? = nil, name: String, email: String, avatar: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.avatar = avatar
        self.password = password
    }
    
}

extension User: Content { }

extension User {
        
    struct Input: Content {
        var name: String
        var email: String
        var avatar: String
        var password: String
    }
    
    struct Output: Content {
        var id: UUID?
        var name: String
        var avatar: String
        var email: String
    }
    
    static func create(from input: Input) throws -> User {
        User(name: input.name, email: input.email, avatar: input.avatar, password: try Bcrypt.hash(input.password))
    }
    
    var `public`: Output {
        Output(id: self.id,name: self.name, avatar: self.avatar, email: self.email)
    }
    
}

extension User {
    
    func createToken(source: SessionSource) throws -> Token {
        let token = [UInt8].random(count: 16).base64
        let calendar = Calendar(identifier: .gregorian)
        let expiryDate = calendar.date(byAdding: .year, value: 1, to: Date())
        return try Token(userId: requireID(), token: token, source: source, expiresAt: expiryDate)
    }
    
}

extension User: ModelAuthenticatable {
    
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
    
}
