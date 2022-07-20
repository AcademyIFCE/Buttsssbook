//
//  Post.swift
//  App
//
//  Created by Mateus Rodrigues on 03/05/20.
//

import Vapor
import Fluent
import Foundation

final class Post: Model {
    
    static let schema = "posts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "image")
    var media: String?
    
    @Parent(key: "user_id")
    var user: User
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(content: String, media: String? = nil, userID: User.IDValue) {
        self.content = content
        self.media = media
        self.$user.id = userID
    }
    
    init(form: Form, userID: User.IDValue) {
        self.content = form.content
        self.media = try? form.media?.data.write(to: URL(fileURLWithPath: DirectoryConfiguration.detect().publicDirectory))
        self.$user.id = userID
    }
    
    var `public`: Output1 {
        Output1(id: id!, content: content, media: media, createdAt: createdAt, updatedAt: updatedAt, userID: $user.id)
    }
    
}

extension Post: Content { }

extension Post {
    
    struct Form: Content {
        var content: String
        var media: File?
    }
    
    struct Output1: Content {
        var id: UUID
        var content: String
        var media: String?
        var createdAt: Date?
        var updatedAt: Date?
        var userID: UUID
    }
    
    struct Output2: Content {
        var id: UUID
        var content: String
        var image: String?
        var createdAt: Date?
        var userID: UUID
        var user: User.Output
    }
    
}
