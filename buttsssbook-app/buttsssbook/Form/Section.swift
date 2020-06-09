//
//  Section.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 13/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import Foundation

struct Section {
    var rows: [Row]
}

extension Section {
    
    init(@Builder _ content: () -> Row) {
        self.init(rows: [content()])
    }
    
    init(@Builder _ content: () -> [Row]) {
        self.init(rows: content())
    }
    
    @_functionBuilder
    struct Builder {
        static func buildBlock(_ rows: Row...) -> [Row] {
            return rows
        }
    }
    
}

/*
MARK: Guiding Resources
 
https://www.andyibanez.com/posts/understanding-function-builders/
https://forums.swift.org/t/function-builders/25167/383

*/

