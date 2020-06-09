//
//  HTTP+Authentication.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 14/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

enum HTTPAuthentication {
    
    case basic(username: String, password: String)
    case bearer(token: String)
    
    var value: String {
        switch self {
        case .basic(let username, let password):
            let credentials = "\(username):\(password)".data(using: .utf8)!.base64EncodedString()
            return "Basic \(credentials)"
        case .bearer(let token):
            return "Bearer \(token)"
        }
    }
    
}

/*
 
MARK: Guiding Resources

https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication
https://developerslogblog.wordpress.com/2017/02/26/basic-authentication-in-swift-3-0/
https://stackoverflow.com/questions/44800293/issue-with-sending-bearer-token-in-http-header-using-urlsession-in-swift-3

*/
