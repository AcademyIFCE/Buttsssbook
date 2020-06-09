//
//  SettingsViewController.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 18/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(InfoCell.self, forCellReuseIdentifier: "info-cell")
            tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "button-cell")
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 50
        }
    }
    
    var signInView = UIStackView()
    
    var user: User!
    
    let infos = [User.Info(name: "Name", key: \.name), User.Info(name: "Email", key: \.email)]
    
    var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        super.loadView()
        
        self.view.add(signInView) {
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
            
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 10
            
            $0.add(SignInWithAppleButton()) {
                $0.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
                $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
            }
            
            $0.add(UILabel()) {
                $0.font = UIFont.preferredFont(forTextStyle: .footnote)
                $0.textAlignment = .center
                $0.text = "- or -"
            }
            
            $0.add(UIButton()) {
                $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
                $0.setTitle("SIGN IN WITH EMAIL", for: .normal)
                $0.setTitleColor(.systemBlue, for: .normal)
                $0.addTarget(self, action: #selector(signInWithEmail), for: .touchUpInside)
                $0.contentEdgeInsets.top = .leastNonzeroMagnitude
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Storage.$session.publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: update(for:))
            .store(in: &cancellables)
    }
    
    func update(for session: Session?) {
        switch session {
        case .some:
            self.user = session?.user
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.signInView.isHidden = true
        case .none:
            self.tableView.isHidden = true
            self.signInView.isHidden = false
        }
    }
    
    @objc func signInWithApple(_ sender: Any) {
        // TODO
    }
    
    @objc func signInWithEmail(_ sender: Any) {
        performSegue(withIdentifier: "sign-in-with-email", sender: nil)
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch Section(rawValue: section)! {
        case .user:
            return AvatarView(image: GIF(named: user.avatar)?.static, target: self, action: #selector(selectAvatar))
        case .button:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Section(rawValue: section)! {
        case .user:
            return 120
        case .button:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch user {
        case .some:
            return Section.allCases.count
        case .none:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .user:
            return 2
        case .button:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(indexPath: indexPath)! {
        case .user:
            let cell = tableView.dequeueReusableCell(withIdentifier: "info-cell", for: indexPath) as! InfoCell
            cell.configure(with: infos[indexPath.row], from: user)
            return cell
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: "button-cell", for: indexPath) as! ButtonCell
            cell.configure(title: "Sign Out", color: .systemRed, target: self, action: #selector(signOut))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @objc func selectAvatar(_ sender: Any) {
        performSegue(withIdentifier: "select-buttsss", sender: nil)
    }
    
    @objc func signOut(_ sender: Any) {
        Service.default.signOut { result in
            switch result {
            case .success:
                Storage.session = nil
            case .failure(let error):
                DispatchQueue.main.async {
                    self.present(UIAlertController(error: error), animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension ProfileViewController {
    
    enum Section: Int, CaseIterable {
        
        case user
        case button
        
        init?(indexPath: IndexPath) {
            self.init(rawValue: indexPath.section)
        }
        
    }
    
}

/*

MARK: Guiding Resources

https://www.swiftbysundell.com/articles/encapsulating-configuration-code-in-swift/
https://www.thomashanning.com/structuring-uitableviews-enums/
 
*/
