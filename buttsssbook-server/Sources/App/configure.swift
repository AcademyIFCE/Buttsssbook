import Vapor
import Fluent
import FluentSQLiteDriver

public func configure(_ app: Application) throws {
    
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreatePost())
    app.migrations.add(CreateToken())
    
    ContentConfiguration.global.use(encoder: JSONEncoder(), for: .json)

    
    try app.autoMigrate().wait()
    
    try routes(app)
}
