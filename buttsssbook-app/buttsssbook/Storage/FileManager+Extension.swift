//
//  FileManager+Extension.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 24/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

extension FileManager {
    
    @discardableResult
    func encode<T: Encodable>(_ value: T, to file: String) -> URL? {
        let url = self.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(file)
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url)
            return url
        } catch {
            print(#function, error.localizedDescription)
            return nil
        }
    }
    
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        let url = self.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(file)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(#function, error.localizedDescription)
            return nil
        }
    }
    
}
