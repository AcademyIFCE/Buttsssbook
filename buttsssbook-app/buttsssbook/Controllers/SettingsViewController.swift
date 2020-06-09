//
//  SettingsViewController.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 18/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    lazy var signInView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [signInWithAppleButton, orLabel, signInWithEmailButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    lazy var signInWithAppleButton: UIControl = {
        let button = SignInWithAppleButton()
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    lazy var signInWithEmailButton: UIControl = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.setTitle("SIGN IN WITH EMAIL", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentEdgeInsets.top = .leastNonzeroMagnitude
        return button
    }()
    
    lazy var orLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        label.text = "- or -"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signInView)
        signInView.translatesAutoresizingMaskIntoConstraints = false
        signInView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        signInView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    }

}
