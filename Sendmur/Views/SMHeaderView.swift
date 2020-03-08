//
//  SMHeaderView.swift
//  Sendmur
//
//  Created by Angel Fuentes on 04/10/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

class SMHeaderView: UICollectionReusableView {
    
    let imageView: UIImageView = {
        let iv: UIImageView = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 22)
        label.textAlignment = .center
        if #available(iOS 13.0, *) {
            label.textColor = .dynamicColor
        } else {
            label.textColor = .black
        }
        return label
    }()
    
    var animator: UIViewPropertyAnimator!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(with: "V:|-16-[v0(200)]-16-[v1]", views: imageView, nameLabel)
        addConstraints(with: "H:|-[v0]-|", views: nameLabel)
        addConstraints(with: "H:[v0(200)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        setupVisualEffect()
    }
    
    fileprivate func setupVisualEffect() {
        animator = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: { [weak self] in
            self?.imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
            self?.imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        })
        
        animator.fractionComplete = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
