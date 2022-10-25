//
//  RandomUtil.swift
//  Frenly
//
//  Created by Владислав on 23.10.2022.
//

import Foundation

extension UtilsService {
    class Random {
        static func get32BytesHex() throws -> String {
            var bytes = [Int8](repeating: 0, count: 32)
            let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)

            // https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
          
            if status == errSecSuccess {
                return Data(bytes: bytes, count: 32).toHexString()
            }
            
            throw UtilsError.randomGeneratorError
        }
    }
}
