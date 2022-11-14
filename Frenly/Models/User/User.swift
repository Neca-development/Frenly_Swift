//
//  UserInfo.swift
//  Frenly
//
//  Created by Владислав on 03.11.2022.
//

import Foundation

struct User {
    var username: String = UtilsService.User.nameFromWalletAddress(walletAddress: Constants.ETH_NULL_ADDRESS)
    var avatar: String = ""
    var description: String = ""
    var totalFollows: Int = 0
}
