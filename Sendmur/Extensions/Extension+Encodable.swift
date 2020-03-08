//
//  Extension+Encodable.swift
//  Sendmur
//
//  Created by Angel Fuentes on 28/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import Foundation

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
