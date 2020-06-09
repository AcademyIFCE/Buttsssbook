//
//  FormViewController.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 12/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class FormViewController: UITableViewController {
    
    var sections = [Section]()
    
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "text-cell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "button-cell")
      
    }

    // MARK: - table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        if let row = section.rows[indexPath.row] as? TextFieldRow {
            let cell = tableView.dequeueReusableCell(withIdentifier: "text-cell", for: indexPath) as! TextFieldCell
            cell.titleLabel.text = row.title
            cell.textField.isSecureTextEntry = row.isSecureTextEntry
            cell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textFields.append(cell.textField)
            return cell
        }
        else if let row = section.rows[indexPath.row] as? ButtonRow {
            let cell = tableView.dequeueReusableCell(withIdentifier: "button-cell", for: indexPath) as! ButtonCell
            cell.button.setTitle(row.title, for: .normal)
            cell.button.addTarget(row.target, action: row.action, for: .touchUpInside)
            return cell
        } else {
            fatalError()
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        didValidateTextFields(isValid: textFields.allSatisfy { !($0.text!.isEmpty) })
//        self.navigationItem.rightBarButtonItem?.isEnabled = textFields.allSatisfy { !($0.text!.isEmpty) }
//        self.navigationItem.rightBarButtonItem?.isEnabled = textFields.allSatisfy {
//            if let index = textFields.firstIndex(of: $0), let row = rows[index] as? TextRow, let regex = row.regex {
//                return $0.text!.range(of: regex, options: .regularExpression) != nil
//            } else {
//                return !($0.text!.isEmpty)
//            }
//        }
    }
    
    func didValidateTextFields(isValid: Bool) {}
    
    func valueForRowAt(section: Int, row: Int) -> String? {
        (tableView.cellForRow(at: IndexPath(row: row, section: section)) as? TextFieldCell)?.textField.text
    }

}
