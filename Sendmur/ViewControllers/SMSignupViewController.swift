//
//  ViewController.swift
//  Sendmur
//
//  Created by Angel Fuentes on 16/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CodableFirebase

class SMSignupViewController: SMViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 42)
        label.text = "Sign Up"
        return label
    }()
    
    public let usernameTextField: SMTextField = {
        let textField = SMTextField()
        return textField
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
    
    public let registerButton: SMButton = {
        let button = SMButton()
        button.setTitle("REGISTER", for: .normal)
        return button
    }()
    
    public let pictureView: UIButton = {
        let view = UIButton()
        view.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        view.tintColor = .lightGray
        view.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        view.layer.cornerRadius = 40
        return view
    }()
    
    public let pictureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        return imageView
    }()
    
    private let imagePicker: UIImagePickerController = UIImagePickerController()
    private var imageSource: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.addTarget(self, action: #selector(registerAction(_:)), for: .touchUpInside)
        pictureView.addTarget(self, action: #selector(pickImage(_:)), for: .touchUpInside)
    }
    
    @objc
    private func registerAction(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let pass = passTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: pass) { (data, error) in
            self.uploadImageToFireBaseStorage()
        }
    }
    
    @objc
    private func pickImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func uploadImageToFireBaseStorage() {
        let filename = UUID().uuidString
        let ref: StorageReference = Storage.storage().reference(withPath: "/images/\(filename)")
        ref.putFile(from: imageSource!, metadata: nil) { (_, _) in
            ref.downloadURL { (uri, err) in
                guard let url = uri else { return }
                self.saveUserToFirebaseDatabase(profileImageUrl: url.path)
            }
        }
    }
    
    private func saveUserToFirebaseDatabase(profileImageUrl: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let username = usernameTextField.text else { return }
        
        let uid = currentUser.uid
        let ref = Database.database().reference(withPath: "/users/\(uid)")
        var dict: [String: String] = [:]
        
        dict["profileImageUrl"] = profileImageUrl
        dict["uid"] = uid
        
        dict["username"] = username
        
        ref.setValue(dict) { (err, dataRef) in
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        pictureImage.image = info[.originalImage] as? UIImage
        pictureView.isHidden = true
        imageSource = info[.imageURL] as? URL
    }
    
    override func setupView() {
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .dynamicBackgroundColor
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(titleLabel)
        view.addSubview(pictureImage)
        view.addSubview(pictureView)
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passTextField)
        view.addSubview(registerButton)
        
        usernameTextField.placeholder = "Username"
        emailTextField.placeholder = "Email"
        passTextField.placeholder = "Password"
        
        pictureImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(with: "V:|-80-[v0]-32-[v1(80)]-16-[v2(45)]-16-[v3(45)]-16-[v4(45)]", views: titleLabel, pictureView, emailTextField, passTextField, registerButton)
        view.addConstraints(with: "H:|-16-[v0(80)]-16-[v1]-16-|", views: pictureView, usernameTextField)
        view.addConstraints(with: "H:|-16-[v0]-16-|", views: titleLabel)
        view.addConstraints(with: "H:|-16-[v0]-16-|", views: emailTextField)
        view.addConstraints(with: "H:|-16-[v0]-16-|", views: passTextField)
        view.addConstraints(with: "H:[v0(150)]-16-|", views: registerButton)
        
        view.addConstraint(NSLayoutConstraint(item: usernameTextField, attribute: .bottom, relatedBy: .equal, toItem: pictureView, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: usernameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 45))
        view.addConstraint(NSLayoutConstraint(item: pictureImage, attribute: .top, relatedBy: .equal, toItem: pictureView, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: pictureImage, attribute: .leading, relatedBy: .equal, toItem: pictureView, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: pictureImage, attribute: .trailing, relatedBy: .equal, toItem: pictureView, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: pictureImage, attribute: .bottom, relatedBy: .equal, toItem: pictureView, attribute: .bottom, multiplier: 1, constant: 0))
        
    }

}
