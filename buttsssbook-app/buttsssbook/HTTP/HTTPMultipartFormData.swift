//
//  HTTPMultipartFormData.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 18/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

struct HTTPMultipartFormData {
    
    var boundary = "Boundary-\(UUID().uuidString)"
    var fields: [String: Value] = [:]
    
    subscript(fieldName: String) -> Value? {
        get {
            fields[fieldName]
        }
        set {
            fields[fieldName] = newValue
        }
    }
    
    func data() -> Data {
        var data = Data()
        fields.forEach {
            data.append(encode($0.value, fieldName: $0.key))
        }
        data.append("--\(boundary)--".data(using: .utf8)!)
        return data
    }
    
    private func encode(_ value: Value, fieldName: String) -> Data {
        switch value {
        case .text(let string):
            return encode(text: string, fieldName: fieldName)
        case .file(let data, let name, let mimeType):
            return encode(file: data, fileName: name, mimeType: mimeType, fieldName: fieldName)
        }
    }
    
    private func encode(text: String, fieldName: String) -> Data {
        "--\(boundary)\r\n"
            .appending("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n")
            .appending("\r\n")
            .appending("\(text)\r\n")
            .data(using: .utf8)!
    }
    
    private func encode(file: Data, fileName: String, mimeType: String, fieldName: String) -> Data {
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        data.append(file)
        data.append("\r\n".data(using: .utf8)!)
        return data
    }
    
}

extension HTTPMultipartFormData {
    enum Value {
        case text(String)
        case file(data: Data, name: String, mimeType: String)
    }
}

/*
 
MARK: Guiding Resources
 
https://www.donnywals.com/uploading-images-and-forms-to-a-server-using-urlsession/
https://www.swiftbysundell.com/articles/the-power-of-subscripts-in-swift/
 
*/
