//
//  SignInWithAppleButton.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 09/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import AuthenticationServices

class SignInWithAppleButton: UIControl {
    
    private lazy var white = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    private lazy var black = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [white, black].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            $0.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            $0.topAnchor.constraint(equalTo: topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        setup()
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        white.addTarget(target, action: action, for: controlEvents)
        black.addTarget(target, action: action, for: controlEvents)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return white
        case .light, .unspecified:
            return black
        @unknown default:
            fatalError()
        }
    }
    
    private func setup() {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            black.isHidden = true
            white.isHidden = false
        case .light, .unspecified:
            white.isHidden = true
            black.isHidden = false
        @unknown default:
            fatalError()
        }
    }
    
}
