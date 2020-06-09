//
//  UserDefault.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 19/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation
import Combine

@propertyWrapper
struct Store<T> {
    
    let key: String
    let publisher: CurrentValueSubject<T?, Never>

    init(_ key: String) {
        self.key = key
        self.publisher = CurrentValueSubject(UserDefaults.standard.object(forKey: self.key) as? T)
    }
    
    var projectedValue: Store<T> { self }

    var wrappedValue: T? {
        get {
            publisher.value
        }
        set {
            publisher.send(newValue)
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
}
