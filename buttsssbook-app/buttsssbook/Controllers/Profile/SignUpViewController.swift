//
//  SignUpViewController.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 13/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class SignUpViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sections = [
            Section {
                TextFieldRow(title: "Name", isSecureTextEntry: false)
                TextFieldRow(title: "Email", isSecureTextEntry: false)
                TextFieldRow(title: "Password", isSecureTextEntry: true)
            }
        ]
    }
    
    @IBAction func create(_ sender: Any) {
        
        guard let name = valueForRowAt(section: 0, row: 0) else { return }
        guard let email = valueForRowAt(section: 0, row: 1) else { return }
        guard let password = valueForRowAt(section: 0, row: 2) else { return }
        
        navigationItem.rightBarButtonItem?.setLoading(true)
        
        Service.default.signUp(name: name, email: email, avatar: "no-butt", password: password) { result in
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.setLoading(false)
                switch result {
                case .failure(let error):
                    self.present(UIAlertController(error: error), animated: true, completion: nil)
                case .success(let session):
                    Storage.session = session
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }

}
