//
//  PostCell.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 10/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with post: Post, contextMenuDelegate delegate: UIContextMenuInteractionDelegate) {
        nameLabel.text = post.user.name
        contentTextView.text = post.content
        if let image = post.image {
            contentImageView.isHidden = false
            contentImageView.loadImage(from: Service.default.baseURL.appendingPathComponent(image))
        } else {
            contentImageView.isHidden = true
            contentImageView.image = nil
        }
        if let gif = GIF(named: post.user.avatar) {
            avatarImageView.image = gif.static
            avatarImageView.contentMode = .scaleAspectFit
            avatarImageView.isUserInteractionEnabled = true
            avatarImageView.addInteraction(UIContextMenuInteraction(delegate: delegate))
        }
        createdAtLabel.text = RelativeDateTimeFormatter().localizedString(for: post.createdAt, relativeTo: Date())
    }
    
}
