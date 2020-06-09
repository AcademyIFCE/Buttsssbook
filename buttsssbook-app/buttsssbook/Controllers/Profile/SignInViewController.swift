//
//  SignInViewController.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 13/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class SignInViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sections = [
            Section {
                TextFieldRow(title: "Email", isSecureTextEntry: false)
                TextFieldRow(title: "Password", isSecureTextEntry: true)
            },
            Section{
                ButtonRow(title: "Create New Account", target: self, action: #selector(signUp))
            }
        ]
    }
    
    @IBAction func signIn(_ sender: Any) {
        
        guard let email = valueForRowAt(section: 0, row: 0) else { return }
        guard let password = valueForRowAt(section: 0, row: 1) else { return }
        
        navigationItem.rightBarButtonItem?.setLoading(true)
        
        Service.default.signIn(email: email, password: password) { (result) in
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
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func signUp() {
        self.performSegue(withIdentifier: "sign-up", sender: nil)
    }
    
}
