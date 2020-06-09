//
//  UIAlertController+Extension.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 17/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(error: Error) {
        self.init(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
}
