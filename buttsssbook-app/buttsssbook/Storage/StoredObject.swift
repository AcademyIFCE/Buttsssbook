//
//  UserDefault.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 19/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation
import Combine

typealias Keychain = KeychainWrapper

@propertyWrapper
struct StoredObject<T: Codable> {
    
    let key: String
    let location: Location
    
    let publisher: CurrentValueSubject<T?, Never>
    
    init(key: String, location: Location) {
        self.key = key
        self.location = location
        self.publisher = .init(nil)
        switch location {
        case .userDefaults:
            if let data = UserDefaults.standard.data(forKey: key) {
                publisher.send(try? JSONDecoder().decode(T.self, from: data))
            }
        case .keychain:
            if let data = Keychain.standard.data(forKey: key) {
                publisher.send(try? JSONDecoder().decode(T.self, from: data))
            }
        case .fileManager:
            if let object = FileManager.default.decode(T.self, from: key) {
                publisher.send(object)

            }
        }
    }
    
    var projectedValue: StoredObject<T> { self }

    var wrappedValue: T? {
        get {
            publisher.value
        }
        set {
            switch location {
            case .userDefaults:
                if let data = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(data, forKey: key)
                } else {
                    UserDefaults.standard.removeObject(forKey: key)
                }
            case .keychain:
                if let data = try? JSONEncoder().encode(newValue) {
                    Keychain.standard.set(data, forKey: key)
                } else {
                    Keychain.standard.removeObject(forKey: key)
                }
            case .fileManager:
                if let object = newValue {
                    FileManager.default.encode(object, to: key)
                }
            }
            publisher.send(newValue)
        }
    }
    
}

extension StoredObject {
    enum Location {
        case userDefaults
        case keychain
        case fileManager
    }
}

/*

MARK: Guiding Resources

https://www.vadimbulavin.com/swift-5-property-wrappers/
https://www.vadimbulavin.com/swift-combine-framework-tutorial-getting-started
https://swiftsenpai.com/swift/create-the-perfect-userdefaults-wrapper-using-property-wrapper/
https://dev.to/kodelit/userdefaults-property-wrapper-issues-solutions-4lk9/
https://github.com/jrendel/SwiftKeychainWrapper
https://www.raywenderlich.com/9240-keychain-services-api-tutorial-for-passwords-in-swift
 
*/
