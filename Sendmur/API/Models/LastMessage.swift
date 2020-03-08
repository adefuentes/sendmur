//
//  LastMessage.swift
//  Sendmur
//
//  Created by Angel Fuentes on 22/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import Foundation

class LastMessage: Codable {
    
    var id: String
    var fromId: String
    var toId: String
    var text: String
    var timestamp: Int
    
}
