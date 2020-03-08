//
//  SignUpModel.swift
//  Sendmur
//
//  Created by Angel Fuentes on 28/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import Foundation

public class SMSignUpModel {
    static var savedUser: User? {
        set {
            UserDefaults.standard.set(newValue, forKey: "user")
        }
        get {
            UserDefaults.standard.value(forKey: "user") as? User
        }
    }
    static var currentUser: User?
}
