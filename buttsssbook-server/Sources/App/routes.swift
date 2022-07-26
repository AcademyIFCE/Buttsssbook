import Vapor

func routes(_ app: Application) throws {
    
    try app.register(collection: UserController())
    try app.register(collection: PostController())
    try app.register(collection: ChatController())
    try app.register(collection: LikeController())
    
    app.routes.get("documentation") { req in
        req.view.render(app.directory.publicDirectory + "documentation/index.html")
    }
    
    app.routes.post("foo") { req -> Response in
        let uuid = try req.content.decode(UUID.self)
        print("FOO: \(uuid)")
        return Response(status: .noContent)
    }
    
}
