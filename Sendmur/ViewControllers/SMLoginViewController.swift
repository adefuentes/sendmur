//
//  SMLoginViewController.swift
//  Sendmur
//
//  Created by Angel Fuentes on 16/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit
import FirebaseAuth

class SMLoginViewController: SMViewController {
    
    public let pullUpView: SMPullUp = {
        let pullUpView = SMPullUp()
        pullUpView.text = "Already account?"
        return pullUpView
    }()
    
    public let emailTextField: SMTextField = {
        let textField = SMTextField()
        return textField
    }()
    
    public let passTextField: SMTextField = {
        let textField = SMTextField()
        textField.isSecureTextEntry = true
        return textField
    }()
    
    public let loginButton: SMButton = {
        let button = SMButton()
        button.colors = [UIColor(rgb: 0x55EFCB).cgColor, UIColor(rgb: 0x5BCAFF).cgColor]
        button.setTitle("ACCESS", for: .normal)
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: #selector(actionLogin(_:)), for: .touchUpInside)
    }
    
    @objc
    private func actionLogin(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let pass = passTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            guard let _ = result else { return }
            let vc = SMLastMessagesViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func setupView() {
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .dynamicBackgroundColor
        } else {
            view.backgroundColor = .white
        }
        
        emailTextField.placeholder = "Email"
        passTextField.placeholder = "Password"
        
        view.addSubview(pullUpView)
        view.addSubview(emailTextField)
        view.addSubview(passTextField)
        view.addSubview(loginButton)
        
        pullUpView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(with: "H:|[v0]|", views: pullUpView)
        view.addConstraints(with: "V:|-8-[v0(120)]-32-[v1(45)]-16-[v2(45)]-16-[v3(45)]", views: pullUpView, emailTextField, passTextField, loginButton)
        view.addConstraints(with: "H:|-16-[v0]-16-|", views: emailTextField)
        view.addConstraints(with: "H:|-16-[v0]-16-|", views: passTextField)
        view.addConstraints(with: "H:[v0(150)]-16-|", views: loginButton)
        
    }
    
}
