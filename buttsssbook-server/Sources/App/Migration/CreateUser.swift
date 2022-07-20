//
//  CreateUser.swift
//  App
//
//  Created by Mateus Rodrigues on 03/05/20.
//

import Vapor
import Fluent

//struct CreateUser: Migration {
//
//    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        database
//            .schema(User.schema)
//            .id()
//            .field("name", .string)
//            .field("email", .string)
//            .field("avatar", .string)
//            .unique(on: "email")
//            .field("password", .string)
//            .create()
//    }
//
//    func revert(on database: Database) -> EventLoopFuture<Void> {
//        database.schema(User.schema).delete()
//    }
//
//}

struct CreateUser: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database
            .schema(User.schema)
            .id()
            .field("name", .string)
            .field("email", .string)
            .field("avatar", .string)
            .unique(on: "email")
            .field("password", .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
    
}
