//
//  InfoCell.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 20/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with info: User.Info, from user: User) {
        textLabel?.text = info.name
        detailTextLabel?.text = user[keyPath: info.key]
    }

}
