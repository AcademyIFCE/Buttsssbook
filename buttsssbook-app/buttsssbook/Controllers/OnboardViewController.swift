//
//  OnboardViewController.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 08/06/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import WebKit

class OnboardViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.layer.cornerRadius = 10
            button.layer.cornerCurve = .continuous
        }
    }
    
    let url = URL(string: "https://www.youtube.com/embed/jrZD6ECwcqo?playsinline=1")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
        button.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Storage.hasSeenAppIntroduction = true
    }
    
    @objc func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
