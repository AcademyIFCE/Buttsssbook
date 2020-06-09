//
//  Storage.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 07/06/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

struct Storage {
    
    @StoredObject(key: "has_seen_app_introduction", location: .userDefaults)
    static var hasSeenAppIntroduction: Bool?
    
    @StoredObject(key: "service_session", location: .keychain)
    static var session: Session?
    
    @StoredObject(key: "chat_messages", location: .fileManager)
    static var messages: [Message]?
    
}
