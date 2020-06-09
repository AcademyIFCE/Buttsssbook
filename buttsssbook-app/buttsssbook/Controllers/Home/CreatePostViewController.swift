//
//  CreatePostViewController.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 10/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import Combine

class CreatePostViewController: UITableViewController {
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                            target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "camera", withConfiguration: UIImage.SymbolConfiguration(weight: .light)),
                            style: .plain, target: nil, action:#selector(pickImage(sender:))),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                            target: nil, action: nil),
        ]
        toolbar.clipsToBounds = true
        toolbar.sizeToFit()
        return toolbar
    }()
    
    private lazy var imagePicker = ImagePicker(presentationController: self, delegate: self)
    
    private var text: String?
    private var image: UIImage?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: "text-cell")
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "image-cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        } else {
            return 200
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (image == nil) ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "text-cell", for: indexPath) as! TextCell
            cell.configure(delegate: self, toolbar: toolbar)
            cell.textView.becomeFirstResponder()
            self.text = cell.textView.text
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "image-cell", for: indexPath) as! ImageCell
            cell.configure(image: image, target: self, action: #selector(delete(sender:)))
            return cell
        }
    }
    
    @objc func delete(sender: Any) {
        self.image = nil
        tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
        toolbar.items?.forEach { $0.isEnabled = true }
    }
    
    @objc func pickImage(sender: Any) {
        imagePicker.present(from: self.view)
    }
    
    @IBAction func post(_ sender: UIBarButtonItem) {
        guard let text = text else { return }
        navigationItem.rightBarButtonItem?.setLoading(true)
        Service.default.create(.init(content: text, image: image), completion: handle(create:))
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func handle(create result: Result<Post, Service.Error>) {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.setLoading(false)
            switch result {
            case .success:
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self.present(UIAlertController(error: error), animated: true, completion: nil)
            }
        }
    }
    
}

extension CreatePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.text = textView.text
        let size = textView.bounds.size
        let sizeThatFits = tableView.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude))
        if size.height != sizeThatFits.height {
            UIView.setAnimationsEnabled(false)
            tableView.performBatchUpdates(nil, completion: nil)
            UIView.setAnimationsEnabled(true)
        }
    }
}

extension CreatePostViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        self.image = image
        tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        toolbar.items?.forEach { $0.isEnabled = false }
    }
}




