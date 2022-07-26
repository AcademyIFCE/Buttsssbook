import Foundation

struct Message: Codable {
    let user: User.Output
    let text: String
}
