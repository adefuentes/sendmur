//
//  SMUserViewCell.swift
//  Sendmur
//
//  Created by Angel Fuentes on 02/10/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

class SMUserViewCell: UICollectionViewCell {
    
    private var user: User?
    
    public let userProfile: UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        
        return imageView
        
    }()
    
    public let usernameLabel: UILabel = {
        
        let label = UILabel()
        if #available(iOS 13.0, *) {
            label.textColor = .dynamicColor
        } else {
            label.textColor = .black
        }
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    private func setupViews() {
        
        addSubview(userProfile)
        addSubview(usernameLabel)
        
        userProfile.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(with: "H:|-16-[v0(50)]-[v1]-|", views: userProfile, usernameLabel)
        addConstraints(with: "V:[v0(50)]", views: userProfile)
        
        addConstraint(NSLayoutConstraint(item: userProfile, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: usernameLabel, attribute: .centerY, relatedBy: .equal, toItem: userProfile, attribute: .centerY, multiplier: 1, constant: 0))
        
        
    }
    
    public func configure(data: User) {
        userProfile.downloaded(from: data.profileImageUrl, contentMode: .scaleAspectFill)
        usernameLabel.text = data.username
        user = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
