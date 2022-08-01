import Vapor
import Fluent

final class Post: Model {
    
    typealias Public = Output1
    
    static let schema = "posts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "media")
    var media: String?
    
    @Field(key: "like_count")
    var likeCount: Int
    
    @Parent(key: "user_id")
    var user: User
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(content: String, media: String? = nil, userID: User.IDValue) {
        self.content = content
        self.media = media
        self.likeCount = 0
        self.$user.id = userID
    }
    
    init(form: Form, userID: User.IDValue) {
        self.content = form.content
        if let media = form.media {
            self.media = try? media.data.write(to: URL(fileURLWithPath: DirectoryConfiguration.detect().publicDirectory), contentType: media.contentType)
        }
        self.$user.id = userID
    }
    
    var `public`: Public {
//        Output2(id: id!, content: content, media: media, createdAt: createdAt, updatedAt: updatedAt, user: user.public)
        Output1(id: id!, content: content, media: media, likeCount: likeCount, createdAt: createdAt, updatedAt: updatedAt, userID: $user.id)
    }
    
}

extension Post: Content { }

extension Post {
    
    struct Form: Content {
        var content: String
        var media: File?
    }
    
    struct Output1: Content {
        var id: UUID
        var content: String
        var media: String?
        var likeCount: Int
        var createdAt: Date?
        var updatedAt: Date?
        var userID: UUID
    }
    
    struct Output2: Content {
        var id: UUID
        var content: String
        var media: String?
        var createdAt: Date?
        var updatedAt: Date?
        var user: User.Output
    }
    
}
