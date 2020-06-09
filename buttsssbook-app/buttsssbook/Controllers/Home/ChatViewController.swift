//
//  ChatViewController.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 21/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import Combine

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "BubbleCell", bundle: nil), forCellReuseIdentifier: "bubble-cell")
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 50.0
            tableView.dataSource = self
            
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            textView.layer.cornerRadius = textView.layer.frame.height/2
            textView.clipsToBounds = true
        }
        
    }
    
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.imageView?.contentMode = .scaleAspectFill
            button.addTarget(self, action: #selector(send), for: .touchUpInside)
        }
    }
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    var user: User!
    
    var messages = [Message]()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messages = Storage.messages ?? []
        
        Storage.$session.publisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in self.update(for: $0)}
            .store(in: &cancellables)
        
        
        KeyboardState.notifications.forEach {
            NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: $0, object: nil)
        }
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let state = KeyboardState(notification) else { return }
        switch state {
        case .willShow(let height):
            bottomConstraint.constant = height
        case .willHide:
            bottomConstraint.constant = 0
        default:
            return
        }
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        } , completion: { _ in
            let lastIndexPath = IndexPath(row: self.messages.count-1, section: 0)
            if case .willShow = state {
                self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            } else {
                self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    func update(for session: Session?) {
        if let session = session {
            user = session.user
            Chat.default.connect(authentication: .bearer(token: session.token))
            Chat.default.onReceive { [weak self] in self?.handle($0) }
            tableView.reloadData()
        }
    }
    
    private func handle(_ result: Result<Message, Service.Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let message):
                self.messages.append(message)
                self.tableView.reloadData()
                Storage.messages = self.messages
            case .failure(let error):
                self.present(UIAlertController(error: error), animated: true, completion: nil)
            }
        }
    }
    
    @objc func send(_ sender: Any) {
        let message = textView.text!
        Chat.default.send(message) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.present(UIAlertController(error: error), animated: true, completion: nil)
                }
            }
        }
        textView.text = nil
        textView.resignFirstResponder()
    }

}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        user == nil ? 0 : messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bubble-cell", for: indexPath) as! BubbleCell
        cell.configure(with: messages[indexPath.row], me: user)
        return cell
    }
    
}
