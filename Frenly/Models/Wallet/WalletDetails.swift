//
//  WalletDetails.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import Foundation

public struct WalletDetails {
    public let address: String
    public let chainId: Int

    public init(address: String, chainId: Int) {
        self.address = address
        self.chainId = chainId
    }
}
