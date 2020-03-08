//
//  ChatMessage.swift
//  Sendmur
//
//  Created by Angel Fuentes on 11/10/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import Foundation

class ChatMessage: Codable {
    
    var id: String
    var text: String
    var fromId: String
    var toId: String
    var timestamp: Int16
    
}
