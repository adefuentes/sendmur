//
//  SMFromMessageViewCell.swift
//  Sendmur
//
//  Created by Angel Fuentes on 04/10/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

class SMFromMessageViewCell: SMMessageCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setupViews() {
        
        if #available(iOS 13.0, *) {
            wrapperMessage.backgroundColor = .dynamicBorderdColor
        } else {
            wrapperMessage.backgroundColor = UIColor(white: 0.8, alpha: 1)
        }
        
        super.setupViews()
        
        wrapperMessage.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        wrapperMessage.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
