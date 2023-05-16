//
//  ImageView.swift
//  FriendFeedRxSwift
//
//  Created by Long Tran on 12/05/2023.
//

import Foundation
import UIKit

var imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func load(urlString: String) {
        if let image = imageCache.object(forKey: urlString as NSString) {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}
