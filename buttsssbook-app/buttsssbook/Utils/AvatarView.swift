//
//  ButtsssView.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 20/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

final class AvatarView: UIView {
    
    let imageView = UIImageView()
    let label = UILabel()
    
    init(image: UIImage? = nil, target: Any?, action: Selector) {
        super.init(frame: .zero)
        
        addSubview(imageView)
        imageView.addSubview(label)
        
        imageView.image = image
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        label.text = "EDIT"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.backgroundColor = .systemBlue
        
        imageView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20),
            label.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            label.rightAnchor.constraint(equalTo: imageView.rightAnchor),
            label.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        imageView.isUserInteractionEnabled = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
