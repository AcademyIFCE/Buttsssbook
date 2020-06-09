//
//  ButtonCell.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 12/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        button.contentHorizontalAlignment = .center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title: String, color: UIColor, target: Any?, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
    }
    
}
