//
//  Session.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 15/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

struct Session: Codable {
    let token: String
    var user: User
}
