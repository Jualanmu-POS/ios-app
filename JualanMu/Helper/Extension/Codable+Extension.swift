//
//  Codable+Extension.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 21/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
