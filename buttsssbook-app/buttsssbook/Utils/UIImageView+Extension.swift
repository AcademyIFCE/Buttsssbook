//
//  UIImageView+Extension.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 11/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func loadImage(from imageURL: URL) {
        DispatchQueue.main.async {
            self.image = nil
        }
        let cache = URLCache.shared
        let request = URLRequest(url: imageURL)
        DispatchQueue.global().async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    guard let response = response, let data = data else { return }
                    if let image = UIImage(data: data) {
                        let cachedResponse = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedResponse, for: request)
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }).resume()
            }
        }
        
    }
    
}
