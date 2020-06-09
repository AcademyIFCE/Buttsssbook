//
//  ButsssViewController.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 20/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class ButsssViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = .systemGroupedBackground
            collectionView.register(UINib(nibName: "ButsssCell", bundle: nil), forCellWithReuseIdentifier: "butsss-cell")
            collectionView.setCollectionViewLayout(GridFlowLayout(), animated: false)
            collectionView.allowsMultipleSelection = false
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var selectedIndexPath: IndexPath? {
        collectionView.indexPathsForSelectedItems?.first
    }
    
    let gifs = Bundle.main.paths(forResourcesOfType: "gif", inDirectory: nil)
                    .compactMap { URL(string: $0)?.lastPathComponent }
                    .compactMap { GIF(named: $0) }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let current = Storage.session?.user.avatar, let index = gifs.firstIndex(where: {$0.name == current }) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
            }
        }
    }
    
    @IBAction func save(_ sender: Any) {
        guard let selected = selectedIndexPath?.item else { return }
        let avatar = gifs[selected]
        Service.default.change(avatar: avatar.name) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.present(UIAlertController(error: error), animated: true, completion: nil)
                case .success(let user):
                    let current = Service.default.session
                    Storage.session = Session(token: current.token, user: user)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ButsssViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "butsss-cell", for: indexPath) as! ButtsssCell
        cell.configure(with: gifs[indexPath.item])
        return cell
    }
    
}
