import Vapor
import Fluent

struct LikeController: RouteCollection {

    // (GET) likes/liking_users/:post_id
    // (GET) likes/liked_posts/:user_id
    // (POST) likes/
    // (DELETE) likes/:post_id
    
    func boot(routes: RoutesBuilder) throws {
        routes.group("likes") {
            $0.get("liking_users", ":post_id", use: likingUsers)
            $0.get("liked_posts", ":user_id", use: likedPosts)
            $0.grouped(Token.authenticator()).post(use: like)
            $0.grouped(Token.authenticator()).delete(":post_id", use: unlike)
        }
    }
    
    func like(req: Request) async throws -> Like.Output {
        let user = try req.auth.require(User.self)
        let postID = try req.content.decode(UUID.self)
        guard let post = try await Post.find(postID, on: req.db) else {
            throw Abort(.notFound)
        }
        if let _ = try await Like.query(on: req.db).filter(\.$post.$id == postID).first() {
            let output = Like.Output(postID: postID, liked: true)
            return output
        } else {
            let like = try Like(userID: user.requireID(), postID: post.requireID())
            try await like.save(on: req.db)
            post.likeCount += 1
            try await post.save(on: req.db)
            let output = Like.Output(postID: postID, liked: true)
            return output
        }
    }
    
    func unlike(req: Request) async throws -> Like.Output {
        guard let postID = req.parameters.get("post_id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let post = try await Post.find(postID, on: req.db) else {
            throw Abort(.notFound)
        }
        guard let like = try await Like.query(on: req.db).filter(\.$post.$id == postID).first() else {
            throw Abort(.notFound)
        }
        try await like.delete(on: req.db)
        post.likeCount -= 1
        try await post.save(on: req.db)
        let output = Like.Output(postID: postID, liked: false)
        return output
    }
    
    func likingUsers(req: Request) async throws -> [User.Public] {
        guard let postID = req.parameters.get("post_id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let likes = try await Like.query(on: req.db).filter(\.$post.$id == postID).with(\.$user).all()
        return likes.map(\.user.public)
    }
    
    func likedPosts(req: Request) async throws -> [Post.Public] {
        guard let userID = req.parameters.get("user_id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let likes = try await Like.query(on: req.db).filter(\.$user.$id == userID).with(\.$post).all()
        return likes.map(\.post.public)
    }

}
