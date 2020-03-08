//
//  SMPullUp.swift
//  Sendmur
//
//  Created by Angel Fuentes on 16/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

class SMPullUp: UIView {
    
    public var text: String? {
        didSet {
            self.label.text = self.text
        }
    }
    
    public let viewWrapper: UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .dynamicBackgroundColor
        } else {
            view.backgroundColor = .white
        }
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 3.0
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: -8)
        view.layer.masksToBounds = false
        return view
    }()
    
    private let arrowUp: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return view
    }()
    
    public let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 42)
        label.alpha = 0.3
        label.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        addSubview(viewWrapper)
        addSubview(arrowUp)
        addSubview(label)
        
        viewWrapper.translatesAutoresizingMaskIntoConstraints = false
        arrowUp.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(with: "H:|[v0]|", views: viewWrapper)
        addConstraints(with: "V:|[v0]|", views: viewWrapper)
        addConstraints(with: "H:[v0(45)]", views: arrowUp)
        addConstraints(with: "H:|-[v0]-|", views: label)
        addConstraints(with: "V:|-16-[v0(5)]-[v1(45)]", views: arrowUp, label)
        
        addConstraint(NSLayoutConstraint(item: arrowUp, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
