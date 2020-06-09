//
//  LoadingProtocol.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 09/06/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

fileprivate var key: UInt8 = 42

protocol LoadingProtocol: class {
    func setLoading(_ loading: Bool)
}

extension LoadingProtocol {
    
    private var _indicator: UIActivityIndicatorView? {
        get {
            objc_getAssociatedObject(self, &key) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func setLoading(_ loading: Bool, at target: ReferenceWritableKeyPath<Self, UIView?>) {
        if _indicator == nil {
            _indicator = UIActivityIndicatorView(style: .medium)
        }
        switch loading {
        case true:
            self[keyPath: target] = _indicator
            self._indicator?.startAnimating()
        case false:
            self[keyPath: target] = nil
            self._indicator?.stopAnimating()
        }
    }
    
}

extension UIBarButtonItem: LoadingProtocol {
    func setLoading(_ loading: Bool) {
        setLoading(loading, at: \.customView)
    }
}

