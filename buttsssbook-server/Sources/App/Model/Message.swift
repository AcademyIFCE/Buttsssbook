import Foundation

struct Message: Codable {
    let user: User.Public
    let text: String
}
