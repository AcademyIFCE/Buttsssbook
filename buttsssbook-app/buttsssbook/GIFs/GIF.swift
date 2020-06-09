//
//  Gif.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 20/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

struct GIF {
    
    let name: String
    var sequence: [UIImage]
    
    var `static`: UIImage? { sequence.first }
    
    init?(named name: String) {
        
        self.name = name.replacingOccurrences(of: ".gif", with: "")
        self.sequence = []
        
        guard let url = Bundle.main.url(forResource: self.name, withExtension: "gif") else { return nil }

        guard let data = try? Data(contentsOf: url) else { return nil }

        let options = [
            kCGImageSourceShouldAllowFloat as String : true as NSNumber,
            kCGImageSourceCreateThumbnailWithTransform as String : true as NSNumber,
            kCGImageSourceCreateThumbnailFromImageAlways as String : true as NSNumber
        ]

        guard let source = CGImageSourceCreateWithData(data as CFData, options as CFDictionary) else { return nil }
        
        for index in 0 ..< CGImageSourceGetCount(source) {
            CGImageSourceCreateImageAtIndex(source, index, nil).map {
                sequence.append(UIImage(cgImage: $0))
            }
        }
        
    }
    
}

/*
 
MARK: Guiding Resources

https://stackoverflow.com/a/54866291

*/
