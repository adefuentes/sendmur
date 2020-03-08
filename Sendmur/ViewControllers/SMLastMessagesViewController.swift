//
//  LastMessagesViewController.swift
//  Sendmur
//
//  Created by Angel Fuentes on 21/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CodableFirebase

class SMLastMessagesViewController: SMViewController {

    private var current: User?
    private var latestMessagesMap: [String : SMLatestMessageModel] = [:]
    
    private let lastMessagesCollectionViews: SMLastMessagesView = {
        let lastMessagesView = SMLastMessagesView(frame: .zero)
        return lastMessagesView
    }()
    
    private let conversationView: SMConversationView = {
        let layout = UICollectionViewFlowLayout()
        let conversationView = SMConversationView(frame: .zero, collectionViewLayout: layout)
        return conversationView
    }()
    
    private let footerView: SMFooterView = {
        let footerView = SMFooterView(frame: .zero)
        return footerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        footerView.addButton.addTarget(self, action: #selector(openNewMessage(_:)), for: .touchUpInside)
        footerView.sendButton.addTarget(self, action: #selector(performSendMessage(_:)), for: .touchUpInside)
        
        fetchCurrentUser()
        listenForLatestMessages()
        
        
        //setNormalImage(UIBarButtonItem())
        
    }
    
    @objc
    private func openNewMessage(_ sender: UIButton) {
        let layout = UICollectionViewFlowLayout()
        let newMessageVC = SMNewMessageViewController(collectionViewLayout: layout)
        let navigation = UINavigationController(rootViewController: newMessageVC)
        
        newMessageVC.delegate = self
        
        present(navigation, animated: true, completion: nil)
    }
    
    private func fetchCurrentUser() {
        
        let uid = Auth.auth().currentUser?.uid ?? ""
        let ref = Database.database().reference(withPath: "/users/\(uid)")
        
        ref.observe(.value) { snapshot in
            guard let value = snapshot.value else { return }
            do {
                self.current = try FirebaseDecoder().decode(User.self, from: value)
                print(self.current!.username)
            } catch _ {}
        }
        
    }
    
    private func listenForLatestMessages() {
        let fromId = Auth.auth().currentUser?.uid ?? ""
        let ref = Database.database().reference(withPath: "/latest-messages/\(fromId)")
        ref.observe(.value, with: setLastMessage(snapshot:))
    }
    
    private func setLastMessage(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? Dictionary<String, Any> else { return }
        
            
        value.forEach {
            
            let (k, v) = $0
            
            do {
            
                let lastMessage: LastMessage = try FirebaseDecoder().decode(LastMessage.self, from: v)
                
                let chatPartnerId: String = (lastMessage.fromId == current?.uid) ? lastMessage.toId : lastMessage.fromId
                let ref = Database.database().reference(withPath: "users/\(chatPartnerId)")
                let latestMessageModel = SMLatestMessageModel()
                
                latestMessageModel.latestMessage = lastMessage
                
                latestMessagesMap[k] = latestMessageModel
                
                ref.observe(.value) { (snapshot) in
                    guard let val = snapshot.value else { return }
                    do {
                        let user = try FirebaseDecoder().decode(User.self, from: val)
                        self.latestMessagesMap[k]?.user = user
                        self.lastMessagesCollectionViews.data = Array(self.latestMessagesMap.values)
                        
                    } catch _ {}
                }
                
            } catch _ {}
            
        }

    }
    
    @objc
    private func performSendMessage(_ sender: UIButton) {
        
        guard let message = footerView.messageTextField.text else { return }
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = current?.uid else { return }
        
        let ref = Database.database().reference(withPath: "/user-messages/\(fromId)/\(toId)")
        let toRef = Database.database().reference(withPath: "/user-messages/\(toId)/\(fromId)")
        
        let timestamp = NSDate().timeIntervalSince1970
        
        var newMessage: [String: Any] = [:]
        newMessage["id"] = ref.key
        newMessage["fromId"] = fromId
        newMessage["toId"] = toId
        newMessage["timestamp"] = timestamp
        newMessage["text"] = message
        
        ref.observe(.value) { (snapshot) in
            self.footerView.messageTextField.text = ""
            //conversationView.scrollToItem(at: , at: <#T##UICollectionView.ScrollPosition#>, animated: <#T##Bool#>)
        }
        
        ref.setValue(newMessage)
        toRef.setValue(newMessage)
        
        /*
         
         val latestMessageRef = FirebaseDatabase.getInstance().getReference("/latest-messages/$fromId/$toId")
         latestMessageRef.setValue(chatMessage)

         val latestMessageToRef = FirebaseDatabase.getInstance().getReference("/latest-messages/$toId/$fromId")
         latestMessageToRef.setValue(chatMessage)
         
         */
        
        let latestMessageRef = Database.database().reference(withPath: "/latest-messages/\(fromId)/\(toId)")
        latestMessageRef.setValue(newMessage)
        let latestMessageToRef = Database.database().reference(withPath: "/latest-messages/\(toId)/\(fromId)")
        latestMessageToRef.setValue(newMessage)
        
    }
    
    override func setupView() {
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .dynamicBackgroundColor
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(lastMessagesCollectionViews)
        view.addSubview(conversationView)
        view.addSubview(footerView)
        
        lastMessagesCollectionViews.translatesAutoresizingMaskIntoConstraints = false
        conversationView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(with: "H:|[v0(80)][v1]|", views: lastMessagesCollectionViews, conversationView)
        view.addConstraints(with: "H:|[v0]|", views: footerView)
        view.addConstraints(with: "V:|-[v0][v1(60)]-|", views: lastMessagesCollectionViews, footerView)
        view.addConstraints(with: "V:|-[v0][v1]", views: conversationView, footerView)
        
    }
    
    @objc
    private func setNormalImage(_ sender: UIBarButtonItem) {
        try? Auth.auth().signOut()
    }
    
}

extension SMLastMessagesViewController: SMLastMessagesProtocol {
    
    func didSelected(user: User) {
        conversationView.user = user
    }
    
}

extension SMLastMessagesViewController: SMNewMessageDelegate {
    func finish(withUser user: User) {
        conversationView.user = user
    }
}
