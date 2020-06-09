//
//  ButsssCell.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 20/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class ButtsssCell: UICollectionViewCell {

    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    var gif: GIF?
    
    override var isSelected: Bool {
        didSet {
            guard let gif = gif else { return }
            selectionView.layer.borderWidth = isSelected ? 4 : 0
            imageView.image = nil
            imageView.image = isSelected ? UIImage.animatedImage(with: gif.sequence, duration: 1.0) : gif.static
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionView.layer.cornerRadius = selectionView.layer.frame.size.width/2
        selectionView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        imageView.layer.cornerRadius = imageView.layer.frame.size.width/2
        imageView.contentMode = .scaleAspectFit
    }
    
    func configure(with gif: GIF) {
        self.gif = gif
        self.isSelected = false
    }

}
