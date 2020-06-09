//
//  User.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 10/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: UUID?
    let name: String
    let email: String
    let avatar: String
}

extension User {
    struct Info {
        let name: String
        let key: KeyPath<User, String>
    }
}

