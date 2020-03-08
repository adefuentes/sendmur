//
//  SMTextField.swift
//  Sendmur
//
//  Created by Angel Fuentes on 16/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

class SMTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.05)
        layer.cornerRadius = 15
        
        
    }
    
}
