import Vapor

func routes(_ app: Application) throws {
    
    try app.register(collection: UserController())
    try app.register(collection: PostController())
    try app.register(collection: ChatController())
    
    app.routes.get("documentation") { req in
        req.view.render(app.directory.publicDirectory + "documentation/index.html")
    }

}
