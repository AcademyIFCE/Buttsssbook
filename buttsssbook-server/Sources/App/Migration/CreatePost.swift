//
//  CreatePost.swift
//  App
//
//  Created by Mateus Rodrigues on 03/05/20.
//

import Vapor
import Fluent

//struct CreatePost: Migration {
//    
//    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        database
//            .schema(Post.schema)
//            .id()
//            .field("content", .string)
//            .field("image", .string)
//            .field("created_at", .datetime)
//            .field("updated_at", .datetime)
//            .field("user_id", .uuid)
//            .foreignKey("user_id", references: User.schema, "id", onDelete: .cascade, onUpdate: .cascade)
//            .create()
//    }
//    
//    func revert(on database: Database) -> EventLoopFuture<Void> {
//        database.schema(Post.schema).delete()
//    }
//    
//}

struct CreatePost: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database
            .schema(Post.schema)
            .id()
            .field("content", .string)
            .field("image", .string)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("user_id", .uuid)
            .foreignKey("user_id", references: User.schema, "id", onDelete: .cascade, onUpdate: .cascade)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Post.schema).delete()
    }
    
}

