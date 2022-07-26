import Vapor
import Fluent

struct UserController: RouteCollection {
    
    // (GET) users/
    // (GET) users/:id
    // (GET) users/:id/posts
    // (POST) users/
    // (GET) me/ 🔒
    // (POST) users/logout 🔒
    // (PUT) users/avatar 🔒
    // (POST) users/login 🔒
    
    func boot(routes: RoutesBuilder) throws {
        routes.group("users") {
            $0.get(use: index)
            $0.get(":id", use: show)
            $0.post(use: create)
            $0.group(Token.authenticator()) {
                $0.get("me", use: current)
                $0.put("avatar", use: avatar)
                $0.post("logout", use: logout)
            }
            $0.grouped(User.authenticator()).post("login", use: login)
        }
    }
    
    func create(req: Request) async throws -> Session {
        let input = try req.content.decode(User.Input.self)
        let user = try User(input)
        try await user.save(on: req.db)
        let token = try user.token(source: .signup)
        try await token.save(on: req.db)
        let session = Session(token: token.value, user: user)
        return session
    }
    
    func login(req: Request) async throws -> Session {
        let user = try req.auth.require(User.self)
        let token = try user.token(source: .login)
        try await token.save(on: req.db)
        let session = Session(token: token.value, user: user)
        return session
    }
    
    func logout(req: Request) async throws -> Session {
        let user = try req.auth.require(User.self)
        guard let token = try await Token.query(on: req.db).filter(\.$user.$id == user.id!).first() else {
            throw Abort(.notFound)
        }
        try await token.delete(on: req.db)
        let session = Session(token: token.value, user: user)
        return session
    }
    
    func avatar(req: Request) async throws -> User.Output {
        guard req.headers.contentType == .png || req.headers.contentType == .jpeg else {
            throw Abort(.unsupportedMediaType)
        }
        let user = try req.auth.require(User.self)
        guard let data = req.body.data else {
            throw Abort(.badRequest)
        }
        let avatar = try data.write(to: URL(fileURLWithPath: DirectoryConfiguration.detect().publicDirectory), contentType: req.headers.contentType)
        user.avatar = avatar
        try await user.save(on: req.db)
        return user.public
    }
    
    func current(req: Request) throws -> User.Output {
        try req.auth.require(User.self).public
    }
    
    func index(req: Request) async throws -> [User.Output] {
        let users = try await User.query(on: req.db).with(\.$posts).all()
        return users.map(\.public)
    }
    
    func show(req: Request) async throws -> User.Output {
        guard let id = req.parameters.get("id", as: User.IDValue.self) else {
            throw Abort(.badRequest)
        }
        if let user = try await User.find(id, on: req.db) {
            return user.public
        } else {
            throw Abort(.notFound)
        }
    }
    
}
