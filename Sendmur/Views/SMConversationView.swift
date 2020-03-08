//
//  SMConversationView.swift
//  Sendmur
//
//  Created by Angel Fuentes on 04/10/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

class SMConversationView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    
    var header: SMHeaderView?
    var user: User? {
        didSet {
            reloadData()
        }
    }
    var conversation: [ChatMessage] = []

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        dataSource = self
        delegate = self
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        if #available(iOS 13.0, *) {
            backgroundColor = .dynamicBackgroundColor
        } else {
            backgroundColor = .white
        }
        contentInsetAdjustmentBehavior = .never
        register(SMFromMessageViewCell.self, forCellWithReuseIdentifier: cellId)
        register(SMToMessageViewCell.self, forCellWithReuseIdentifier: cellId)
        register(SMHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY > 0 {
            header?.animator.fractionComplete = 0
            return
        }
        header?.animator.fractionComplete = abs(contentOffsetY) / 100
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId
            , for: indexPath) as? SMHeaderView
    
        header?.imageView.downloaded(from: user?.profileImageUrl ?? "", contentMode: .scaleAspectFill)
        header?.nameLabel.text = user?.username
        
        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: frame.width, height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.conversation.count == 0 && user == nil {
            self.setEmptyMessage("Seleccione una conversación")
        } else {
            self.restore()
        }
        return conversation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}
