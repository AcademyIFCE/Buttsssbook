//
//  TextFieldCell.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 12/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.textField.autocorrectionType = .no
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        textField.becomeFirstResponder()
    }
    
}
