//
//  ViewController.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 04/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import AuthenticationServices
import Combine

class PostsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "post-cell")
            tableView.tableFooterView = UIView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 100
        }
    }
    
    var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var cancellable: AnyCancellable?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Service.default.posts()
//            .receive(on: DispatchQueue.main)
//            .sink(
//                receiveCompletion: {
//                    if case let .failure(error) = $0 {
//                        self.displayAlert(message: error.localizedDescription)
//                    }
//                },
//                receiveValue: { self.posts = $0 })
//            .store(in: &cancellables)
        
        Service.default.posts { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.posts = posts
                case .failure(let error):
                    self.displayAlert(message: error.localizedDescription)
                }
            }
        }
        
    }
    
    func displayAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func action() {
        
    }
    
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post-cell", for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
}

//extension ViewController: ASAuthorizationControllerDelegate {
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
//}
//
//extension ViewController: ASAuthorizationControllerPresentationContextProviding {
//    
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//    
//}

