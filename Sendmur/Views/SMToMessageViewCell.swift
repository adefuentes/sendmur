//
//  SMToMessageViewCell.swift
//  Sendmur
//
//  Created by Angel Fuentes on 04/10/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

class SMToMessageViewCell: SMMessageCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setupViews() {
        
        wrapperMessage.backgroundColor = .systemRed
        
        super.setupViews()
        
        wrapperMessage.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        wrapperMessage.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
