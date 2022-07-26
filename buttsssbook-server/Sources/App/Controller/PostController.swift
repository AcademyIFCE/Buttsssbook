import Vapor
import Fluent

struct PostController: RouteCollection {
    
    // (GET) posts/
    // (POST) posts 🔒
    // (PATCH) posts/:id 🔒
    // (DELETE) posts/:id 🔒
    
    func boot(routes: RoutesBuilder) throws {
        routes.group("posts") {
            $0.get(use: index)
            $0.get(":id", use: show)
            $0.group(Token.authenticator()) {
                $0.post(use: create)
                $0.patch(":id", use: update)
                $0.delete(":id", use: delete)
            }
        }
    }
    
    func index(req: Request) async throws -> [Post.Output1] {
        if let userID = req.query[User.IDValue.self, at: "user_id"] {
            let filteredPosts = try await Post.query(on: req.db).filter(\.$user.$id == userID).sort(\.$createdAt, .descending).all()
            return filteredPosts.map(\.public)
        } else {
            let allPosts = try await Post.query(on: req.db).sort(\.$createdAt, .descending).all()
            return allPosts.map(\.public)
        }
    }
    
    func show(req: Request) async throws -> Post.Output1 {
        guard let id = req.parameters.get("id", as: Post.IDValue.self) else {
            throw Abort(.badRequest)
        }
        if let post = try await Post.find(id, on: req.db) {
            return post.public
        } else {
            throw Abort(.notFound)
        }
    }
    
    func create(req: Request) async throws -> Post.Output1 {
        let user = try req.auth.require(User.self)
        switch req.headers.contentType {
            case .plainText?:
                let content = try req.content.decode(String.self)
                let post = try Post(content: content, userID: user.requireID())
                try await post.save(on: req.db)
                return post.public
            case .multipart?:
                let form = try req.content.decode(Post.Form.self)
                guard let contentType = form.media?.contentType, contentType == [.png, .jpeg, .mpeg] else {
                    throw Abort(.unsupportedMediaType)
                }
                let post = try Post(form: form, userID: user.requireID())
                try await post.save(on: req.db)
                return post.public
            default:
                throw Abort(.badRequest)
        }
    }
    
    func update(req: Request) async throws -> Post {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        if let post = try await Post.find(id, on: req.db) {
            post.content = try req.content.decode(String.self)
            try await post.update(on: req.db)
            return post
        } else {
            throw Abort(.notFound)
        }
    }
    
    func delete(req: Request) async throws -> Post {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        if let post = try await Post.find(id, on: req.db) {
            try await post.delete(on: req.db)
            return post
        } else {
            throw Abort(.notFound)
        }
    }
    
}
