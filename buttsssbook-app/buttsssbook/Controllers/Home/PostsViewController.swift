//
//  ViewController.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 04/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import Combine

class PostsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.refreshControl = .init()
            tableView.refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
            tableView.refreshControl?.layer.zPosition = -1
            tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "post-cell")
            tableView.tableFooterView = UIView()
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 100
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        Storage.$session.publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: update(for:))
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        if Storage.hasSeenAppIntroduction == nil {
            tabBarController?.performSegue(withIdentifier: "onboard", sender: nil)
        }
    }
    
    @objc func load() {
        Service.default.fetch { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.posts = posts
                case .failure(let error):
                    self.present(UIAlertController(error: error), animated: true, completion: nil)
                }
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func update(for session: Session?) {
        switch session {
        case .some:
            self.navigationItem.rightBarButtonItems?.forEach{ $0.isEnabled = true }
        case .none:
            self.navigationItem.rightBarButtonItems?.forEach{ $0.isEnabled = false }
        }
    }
    
    @IBAction func post(_ sender: Any) {
        performSegue(withIdentifier: "post", sender: nil)
    }

    @IBAction func chat(_ sender: Any) {
        performSegue(withIdentifier: "chat", sender: nil)
    }
    
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post-cell", for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row], contextMenuDelegate: self)
        return cell
    }
    
}

extension PostsViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        indexPath(for: interaction, at: location).map {
            configuration(for: posts[$0.row].user.avatar)
        }
    }
    
    func indexPath(for interaction: UIContextMenuInteraction, at location: CGPoint) -> IndexPath? {
        interaction.view.flatMap {
            tableView.indexPathForRow(at: $0.convert(location, to: tableView))
        }
    }
    
    func configuration(for avatar: String) -> UIContextMenuConfiguration {
        let preview = AvatarPreview(for: avatar)
        let name = avatar.replacingOccurrences(of: "-", with: " ").capitalized
        return UIContextMenuConfiguration(identifier: nil, previewProvider: { preview } ) { _ in
            UIMenu(title: "", children: [
                UIAction(title: "\(name) by Pablo Stanley", image: nil, handler: { _ in })
            ])
        }
    }
    
}

//extension ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let credentials as ASAuthorizationAppleIDCredential:
//
//            guard let data = credentials.identityToken, let token = String(data: data, encoding: .utf8) else {
//                return
//            }
//
//            if let fullName = credentials.fullName {
//                print(PersonNameComponentsFormatter().string(from: fullName))
//            }
//
//            var request = URLRequest(url: URL(string: "http://localhost:8080/users/auth")!)
//
//            request.httpMethod = "GET"
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//            print(credentials.user)
//
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                print(response)
//            }
//
//            task.resume()
//
//        default:
//            break
//        }
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print(#function)
//    }
//
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//
//}

/*
 
MARK: Guiding Resources

https://www.raywenderlich.com/6328155-context-menus-tutorial-for-ios-getting-started

*/
