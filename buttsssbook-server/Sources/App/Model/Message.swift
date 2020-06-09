//
//  Message.swift
//  App
//
//  Created by Mateus Rodrigues on 21/05/20.
//

import Foundation

struct Message: Codable {
    let user: User.Output
    let text: String
}
