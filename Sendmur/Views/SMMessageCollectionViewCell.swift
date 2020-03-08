//
//  SMMessageCollectionViewCell.swift
//  Sendmur
//
//  Created by Angel Fuentes on 04/10/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

class SMMessageCollectionViewCell: UICollectionViewCell {
 
    public let messageLabel: UILabel = {
       
        let label = UILabel()

        if #available(iOS 13.0, *) {
            label.textColor = .dynamicColor
        } else {
            label.textColor = .black
        }
        
        return label
        
    }()
    
    internal let wrapperMessage: UIView = {
       
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    internal func setupViews() {
        
        addSubview(wrapperMessage)
        wrapperMessage.addSubview(messageLabel)
        
        wrapperMessage.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        wrapperMessage.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 8).isActive = true
        wrapperMessage.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: 8).isActive = true
        
        wrapperMessage.addConstraints(with: "H:|-[v0]-|", views: messageLabel)
        wrapperMessage.addConstraints(with: "V:|-[v0]-|", views: messageLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
