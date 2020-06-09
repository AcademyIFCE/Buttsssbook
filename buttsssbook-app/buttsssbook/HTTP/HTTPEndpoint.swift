//
//  HTTPEndpoint.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 01/06/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

protocol HTTPEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var body: HTTPBody? { get }
    var authentication: HTTPAuthentication? { get }
    
}
