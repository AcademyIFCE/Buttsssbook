//
//  Post.swift
//  App
//
//  Created by Mateus Rodrigues on 03/05/20.
//

import Vapor
import Fluent

final class Post: Model {
    
    static let schema = "posts"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "content")
    var content: String
    
    @Field(key: "image")
    var image: String?
    
    @Parent(key: "user_id")
    var user: User
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(content: String, image: String?, userID: User.IDValue) {
        self.content = content
        self.image = image
        self.$user.id = userID
    }
    
    init(_ input: Post.Input, userID: User.IDValue) {
        self.content = input.content
        self.image = input.image
        self.$user.id = userID
    }
    
    func `public`() throws -> Output {
        Output(id: try self.requireID(), content: self.content, image: self.image, createdAt: self.createdAt, user: self.user.public)
    }
    
}

extension Post: Content { }

extension Post {
    
    struct Input: Content {
        var content: String
        var image: String?
    }
    
    struct Form: Content {
        var content: String
        var image: File?
    }
    
    struct Output: Content {
        var id: UUID
        var content: String
        var image: String?
        var createdAt: Date?
        var user: User.Output
    }
    
}
