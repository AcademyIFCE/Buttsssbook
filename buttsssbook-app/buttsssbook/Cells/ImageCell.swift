//
//  ImageCell.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 11/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.75)
            button.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        configure(with: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(image: UIImage?, target: Any, action: Selector) {
        button.isHidden = (image == nil) ? true : false
        button.addTarget(target, action: action, for: .touchUpInside)
        contentImageView.image = image
    }
    
}
