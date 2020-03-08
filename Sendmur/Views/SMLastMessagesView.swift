//
//  PELastMessagesView.swift
//  Sendmur
//
//  Created by Angel Fuentes on 27/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

protocol SMLastMessagesProtocol {
    func didSelected(user: User)
}

class SMLastMessagesView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let cellIdentifier = "imageProfileCell"
    public var delegate: SMLastMessagesProtocol?
    public var data: [SMLatestMessageModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var collectionView: UICollectionView = {
       
        let layout  = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        return collectionView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SMImageProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        backgroundColor = .clear
        layer.borderWidth = 0.5
        if #available(iOS 13.0, *) {
            layer.borderColor = UIColor.dynamicBorderdColor.cgColor
        } else {
            layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        }
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(with: "H:|[v0]|", views: collectionView)
        addConstraints(with: "V:|[v0]|", views: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SMImageProfileCell else { return UICollectionViewCell() }
        guard let lastMessage = data?[indexPath.row] else { return cell }
        
        cell.path = lastMessage.user?.profileImageUrl
        cell.state = lastMessage.state
        
        cell.imageView.imageView.downloaded(from: cell.path ?? "", contentMode: .scaleAspectFill) {
            if lastMessage.state == .disabled {
                cell.setBWImage()
            } else {
                cell.setNormalImage()
            }
        }
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        data?.forEach{
            $0.state = .disabled
        }
        
        data?[indexPath.row].state = .selected
        
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.didSelected(user: data![indexPath.row].user!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
