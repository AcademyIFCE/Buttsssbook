//
//  Service+Error.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 15/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

extension Service {
    enum Error {
        case network(Swift.Error)
        case decoding(Swift.Error, Data?)
        case abort(String)
        case unknown(Data?, URLResponse?)
    }
}

struct Abort: Decodable {
    let error: Bool
    let reason: String
}

extension Service.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network(let error), .decoding(let error, _):
            return error.localizedDescription
        case .abort(let reason):
            return reason
        case .unknown:
            return "debug for more details"
        }
    }
}

/*

MARK: Guiding Resources

https://nshipster.com/swift-foundation-error-protocols/
https://www.vadimbulavin.com/the-power-of-namespacing-in-swift/
 
*/
