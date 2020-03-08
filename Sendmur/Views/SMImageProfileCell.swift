//
//  SMImageProfileCell.swift
//  Sendmur
//
//  Created by Angel Fuentes on 26/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit
import AngleGradientLayer

class SMImageProfileCell: UICollectionViewCell {
    
    enum SMImageProfileCellState {
        case selected
        case disabled
    }
    
    public var imageView: SMImageView = {
       
        let imageView = SMImageView()
        imageView.layer.cornerRadius = 27
        imageView.clipsToBounds = true
        
        return imageView
        
    }()
    
    public var state: SMImageProfileCellState = .disabled
    public var path: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    public func setNormalImage() {
        imageView.gradient.colors = imageView.defaultColors
    }
    
    public func setBWImage() {
        
        imageView.gradient.colors = [ UIColor.clear.cgColor ]
        
        guard let currentCGImage = imageView.imageView.image?.cgImage else { return }
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")

        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")

        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return }

        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            imageView.imageView.image = processedImage
        }
        
    }
    
    private func setupViews() {
        
        backgroundColor = .clear
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(with: "V:[v0(54)]", views: imageView)
        addConstraints(with: "H:[v0(54)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SMImageView: UIView {
    
    public var imageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        if #available(iOS 13.0, *) {
            imageView.layer.borderColor = UIColor.dynamicBackgroundColor.cgColor
        } else {
            imageView.layer.borderColor = UIColor.white.cgColor
        }
        
        return imageView
        
    }()
    
    public let gradient = CAGradientLayer()
    public let defaultColors = [
        UIColor(rgb: 0xFF9500).cgColor,
        UIColor(rgb: 0xFF2A68).cgColor,
        UIColor(rgb: 0x5856D6).cgColor,
        UIColor(rgb: 0x1D77EF).cgColor,
        UIColor(rgb: 0x81F3FD).cgColor,
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        gradient.frame = CGRect(x: 0, y: 0, width: 76, height: 76)
        gradient.colors = defaultColors
        layer.addSublayer(gradient)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(with: "V:[v0(50)]", views: imageView)
        addConstraints(with: "H:[v0(50)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
