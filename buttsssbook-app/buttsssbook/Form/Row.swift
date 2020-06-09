//
//  Row.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 13/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

protocol Row {
    var title: String { get }
}

struct TextFieldRow: Row {
    var title: String
    var isSecureTextEntry: Bool
//    var regex: String? = nil
}

struct ButtonRow: Row {
    var title: String
    var target: Any?
    var action: Selector
}
