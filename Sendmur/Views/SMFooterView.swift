//
//  SMFooterView.swift
//  Sendmur
//
//  Created by Angel Fuentes on 02/10/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

class SMFooterView: UIView {
    
    public let addButton: UIButton = {
        
        let button = UIButton()
        
        if #available(iOS 13.0, *) {
            button.backgroundColor = .dynamicColor
            button.tintColor = .dynamicBackgroundColor
        } else {
            button.backgroundColor = .black
            button.tintColor = .white
        }
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        
        button.layer.cornerRadius = 17.5
        
        return button
        
    }()
    
    public let messageTextField: UITextField = {
       
        let textField = UITextField()
        
        textField.backgroundColor = .clear
        textField.placeholder = "Escribe un mensaje..."
        if #available(iOS 13.0, *) {
            textField.textColor = .dynamicColor
        } else {
            textField.textColor = .black
        }
        
        return textField
        
    }()
    
    public let sendButton: UIButton = {
       
        let button = UIButton()
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        gradient.colors = [UIColor(rgb: 0x55EFCB).cgColor, UIColor(rgb: 0x5BCAFF).cgColor]
        button.layer.addSublayer(gradient)
        button.layer.cornerRadius = 17.5
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "send").withRenderingMode(.alwaysTemplate), for: .normal)
        
        if #available(iOS 13.0, *) {
            button.tintColor = .dynamicBackgroundColor
        } else {
            button.tintColor = .white
        }
        
        button.bringSubviewToFront(button.imageView!)
        
        return button
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        
        let stroke = UIView()
        if #available(iOS 13.0, *) {
            stroke.backgroundColor = UIColor.dynamicBorderdColor
        } else {
            stroke.backgroundColor = UIColor(white: 0.8, alpha: 1)
        }
        
        addSubview(stroke)
        addSubview(addButton)
        addSubview(messageTextField)
        addSubview(sendButton)
        stroke.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(with: "H:|-80-[v0]|", views: stroke)
        addConstraints(with: "H:|-20-[v0(35)]-32-[v1]-[v2(35)]-16-|", views: addButton, messageTextField, sendButton)
        
        addConstraints(with: "V:|-(-0.5)-[v0(0.5)]", views: stroke)
        addConstraints(with: "V:[v0(35)]", views: addButton)
        addConstraints(with: "V:|-[v0]-|", views: messageTextField)
        addConstraints(with: "V:[v0(35)]", views: sendButton)
        
        addConstraint(NSLayoutConstraint(item: sendButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: addButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
