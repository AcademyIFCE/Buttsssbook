//
//  PostController.swift
//  App
//
//  Created by Mateus Rodrigues on 03/05/20.
//

import Vapor
import Fluent

struct PostController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.group("posts") {
            $0.get(use: index)
            $0.group(Token.authenticator()) {
                $0.on(.POST, "form", body: .collect(maxSize: "5mb"), use: create)
                $0.delete(":id", use: delete)
            }
        }
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Post.Output]> {
        return Post.query(on: req.db)
            .with(\.$user)
            .sort(\.$createdAt, .descending)
            .all()
            .flatMapEachThrowing { try $0.public() }
    }
    
    func create(req: Request) throws -> EventLoopFuture<Post.Output> {
        let user = try req.auth.require(User.self)
        let form = try req.content.decode(Post.Form.self)
        let path = try form.image.map { try $0.write(to: URL(fileURLWithPath: DirectoryConfiguration.detect().publicDirectory)) }
        let post = try Post(content: form.content, image: path, userID: user.requireID())
        return post.save(on: req.db).flatMap {
            Post.query(on: req.db)
                .filter(\.$id == post.id!)
                .with(\.$user)
                .first()
                .unwrap(or: Abort(.internalServerError))
                .flatMapThrowing { try $0.public() }
        }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Post> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Post.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { post in
                return post.delete(on: req.db).map { post }
            }
    }
    
}

extension File {
    
    fileprivate func write(to directory: URL) throws -> String {
        var buffer = self.data
        guard let file = buffer.readData(length: buffer.readableBytes) else {
            throw Abort(.internalServerError)
        }
        let path = "images/" + UUID().uuidString + ".png"
        let url = directory.appendingPathComponent(path)
        try file.write(to: url)
        return path
    }
    
}


