//
//  BubbleCell.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 21/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class BubbleCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        messageLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with message: Message, me: User) {
        messageLabel.text = message.text
        userLabel.text = message.user.name
        switch message.user.id == me.id {
        case true:
            userLabel.isHidden = true
            stackView.alignment = .trailing
            messageLabel.textAlignment = .right
            bubbleView.backgroundColor = .systemBlue
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            messageLabel.textColor = .white
        case false:
            userLabel.isHidden = false
            stackView.alignment = .leading
            messageLabel.textAlignment = .left
            bubbleView.backgroundColor = .secondarySystemBackground
            bubbleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            messageLabel.textColor = .label
        }
        
    }
    
}
