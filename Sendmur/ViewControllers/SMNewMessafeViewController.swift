//
//  SMNewMessafeViewController.swift
//  Sendmur
//
//  Created by Angel Fuentes on 02/10/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

protocol SMNewMessageDelegate {
    func finish(withUser user: User)
}

class SMNewMessageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var users: [User]? {
        didSet {
            collectionView.reloadData()
        }
    }
    public var delegate: SMNewMessageDelegate?
    private let cellIdentifier = "userCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(SMUserViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        fetchAllUsers()
        title = "Nuevo mensaje"
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .dynamicBackgroundColor
        } else {
            collectionView.backgroundColor = .black
        }
    }
    
    private func fetchAllUsers() {
        
        let ref = Database.database().reference(withPath: "users")
        ref.observe(.value, with: usersObserver(snapshot:))
        
    }
    
    private func usersObserver(snapshot: DataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any] else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var tmp: [User] = []
        
        value.forEach {
            
            let (k, v) = $0
            
            if k != uid {
                do {
                    let user = try FirebaseDecoder().decode(User.self, from: v)
                    tmp.append(user)
                } catch _ {}
            }
            
            
        }
        
        users = tmp
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return users?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SMUserViewCell else { return UICollectionViewCell() }
        guard let user = users?[indexPath.row] else { return cell }
        
        cell.configure(data: user)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = users?[indexPath.row] else { return }
        delegate?.finish(withUser: user)
        dismiss(animated: true, completion: nil)
    }

}
