//
//  UserUtil.swift
//  Frenly
//
//  Created by Владислав on 03.11.2022.
//

import Foundation

extension UtilsService {
    class User {
        static func nameFromWalletAddress(walletAddress: String) -> String {
            // 0x1234000 -> Frenly#1234
            
            if (walletAddress.count < 6) {
                return ""
            }

            let firstIndex = walletAddress.index(walletAddress.startIndex, offsetBy: 2)
            let secondIndex = walletAddress.index(walletAddress.startIndex, offsetBy: 5)
            let indexRange = firstIndex...secondIndex

            let walletNumbers = String(walletAddress[indexRange])
            
            return "Frenly#\(walletNumbers)"
        }
    }
}
