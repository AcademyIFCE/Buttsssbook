//
//  AvatarPreview.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 01/06/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

final class AvatarPreview: UIViewController {
    
    private let imageView = UIImageView()
    
    init(for avatar: String) {
        super.init(nibName: nil, bundle: nil)
        if let gif = GIF(named: avatar) {
            imageView.image = UIImage.animatedImage(with: gif.sequence, duration: 1.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = imageView
        self.preferredContentSize = CGSize(width: 100, height: 100)
    }
    
}
