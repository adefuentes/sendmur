//
//  Extension+UIColor.swift
//  Sendmur
//
//  Created by Angel Fuentes on 21/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    @available(iOS 13.0, *)
    static var dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .unspecified, .light: return .black
        case .dark: return .white
        @unknown default:
            return .black
        }
    }
    
    @available(iOS 13.0, *)
    static var dynamicBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .unspecified, .light: return .white
        case .dark: return .black
        @unknown default:
            return .white
        }
    }
    
    @available(iOS 13.0, *)
    static var dynamicBorderdColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .unspecified, .light: return UIColor(white: 0.8, alpha: 1)
        case .dark: return UIColor(white: 0.2, alpha: 1)
        @unknown default:
            return UIColor(white: 0.8, alpha: 1)
        }
    }
    
}
