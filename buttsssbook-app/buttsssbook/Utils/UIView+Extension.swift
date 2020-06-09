//
//  UIView+Extension.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 26/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func add<T: UIView>(_ subview: T, then closure: (T) -> Void) -> T {
        if let stackView = self as? UIStackView {
            stackView.addArrangedSubview(subview)
        } else {
            addSubview(subview)
        }
        closure(subview)
        return subview
    }
    
}
