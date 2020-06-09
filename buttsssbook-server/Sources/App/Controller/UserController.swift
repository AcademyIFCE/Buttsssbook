//
//  UserController.swift
//  App
//
//  Created by Mateus Rodrigues on 03/05/20.
//

import Vapor
import Fluent

struct Session: Content {
  let token: String
  let user: User
}

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.group("users") {
            $0.get(use: index)
            $0.get(":id", use: show)
            $0.get(":id", "posts", use: posts)
            $0.group(Token.authenticator()) {
                $0.get(use: index)
                $0.get("me", use: current)
                $0.get(":id", use: show)
                $0.get(":id", "posts", use: posts)
                $0.post("logout", use: logout)
                $0.patch("avatar", use: avatar)
            }
            $0.post(use: create)
            $0.grouped(User.authenticator()).post("login", use: login)
        }
    }
    
    func create(req: Request) throws -> EventLoopFuture<Session> {
        let input = try req.content.decode(User.Input.self)
        let user = try User.create(from: input)
        var token: Token!
        return user.save(on: req.db).flatMap {
            guard let _token = try? user.createToken(source: .signup) else {
                return req.eventLoop.future(error: Abort(.internalServerError))
            }
            token = _token
            return token.save(on: req.db)
        }.flatMapThrowing {
            Session(token: token.value, user: user)
        }
    }
    
    func login(req: Request) throws -> EventLoopFuture<Session> {
        let user = try req.auth.require(User.self)
        let token = try user.createToken(source: .login)
        return token.save(on: req.db).flatMapThrowing {
            Session(token: token.value, user: user)
        }
    }
    
    func logout(req: Request) throws -> EventLoopFuture<Session> {
        let user = try req.auth.require(User.self)
        return Token.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { token in
                token.delete(on: req.db).map { Session(token: token.value, user: user) }
            }
    }
    
    func avatar(req: Request) throws -> EventLoopFuture<User.Output> {
        let id = try req.auth.require(User.self).requireID()
        let avatar = try req.content.decode(String.self)
        return User.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.avatar = avatar
                return user.save(on: req.db).map { user.public }
            }
    }
    
    func current(req: Request) throws -> User.Output {
        try req.auth.require(User.self).public
    }
    
    func index(req: Request) throws -> EventLoopFuture<[User.Output]> {
        _ = try req.auth.require(User.self)
        return User.query(on: req.db).with(\.$posts).all().flatMapEachThrowing { $0.public }
    }
    
    func show(req: Request) throws -> EventLoopFuture<User> {
        guard let id = req.parameters.get("id", as: User.IDValue.self) else {
            throw Abort(.badRequest)
        }
        return User.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func posts(req: Request) throws -> EventLoopFuture<[Post]> {
        guard let id = req.parameters.get("id", as: User.IDValue.self) else {
            throw Abort(.badRequest)
        }
        return Post.query(on: req.db).filter(\.$user.$id == id).all()
    }
    
}
