//
//  SMButton.swift
//  Sendmur
//
//  Created by Angel Fuentes on 16/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

class SMButton: UIButton {
    
    public var colors: [CGColor]? {
        didSet {
            self.gradientLayer.colors = self.colors
        }
    }
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        colors = [
            UIColor(red: 26/255, green: 214/255, blue: 253/255, alpha: 1).cgColor,
            UIColor(red: 29/255, green: 99/255, blue: 240/255, alpha: 0.8).cgColor
        ]
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 150, height: 45)
        gradientLayer.cornerRadius = 22.5
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5);
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5);
        
        layer.insertSublayer(gradientLayer, at: 0)
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
    }
    
}
