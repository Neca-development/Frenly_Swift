//
//  Data.swift
//  Frenly
//
//  Created by Владислав on 03.11.2022.
//

import Foundation

extension Data {
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
      }
   }
}
