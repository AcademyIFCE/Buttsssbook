//
//  TextCell.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 11/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(delegate: UITextViewDelegate, toolbar: UIToolbar?) {
        textView.delegate = delegate
        textView.inputAccessoryView = toolbar
    }
    
}
