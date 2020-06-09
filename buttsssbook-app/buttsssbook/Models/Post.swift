//
//  Post.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 10/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

struct Post: Codable {
    let id: UUID
    let content: String
    let image: String?
    let createdAt: Date
    let user: User
}

extension Post {
    struct Request: Codable {
        let content: String
        let image: String?
    }
}

extension Post {
    struct Input {
        let content: String
        let image: UIImage?
    }
}
