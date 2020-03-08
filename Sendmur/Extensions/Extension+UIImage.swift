//
//  Extension+UIImage.swift
//  Sendmur
//
//  Created by Angel Fuentes on 27/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

extension UIImage {
    static func downloaded(from url: URL) -> UIImage {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return UIImage() }
            DispatchQueue.main.async() {
                return image
            }
        }.resume()
        return UIImage()
    }
    static func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        return downloaded(from: url)
    }
}
