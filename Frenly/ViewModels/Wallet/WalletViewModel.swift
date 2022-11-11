//
//  WalletViewModel.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import Foundation
import SwiftUI
import WalletConnectSwift

@MainActor
final class WalletViewModel: ObservableObject {
    @Published var wcStatus: WCStatus = .disconnected
    
    private var wcService: WalletConnectService!
    
    var walletAddress: String? {
        get {
            guard let accounts = wcService.session?.walletInfo?.accounts, let wallet = accounts.first else { return nil }
            
            return wallet
        }
    }

    var chainId: Int? {
        get {
            guard let chainId = wcService.session.walletInfo?.chainId else { return nil }
            
            return chainId
        }
    }
    
    public init() {
        wcService = WalletConnectService(delegate: self)
    }
     
    func connectWallet(walletType: WalletType) async -> Void {
        let wcUrl = wcService.connect(title: "Frenly", description: "Frenly App")
        
        do {
            UserDefaults.standard.set(walletType.rawValue, forKey: Constants.WC_WALLET_TYPE_KEY)
            
            try openExternalWalletApp(wcUrl: wcUrl)
        } catch {
            wcStatus = .failed
            return
        }
    }
    
    func reconnect() -> WalletConnectService.ReconnectStatus {
        return wcService.tryReconnect()
    }
    
    func sign(message: String) async throws -> String {
        let wcUrl = wcService.session.url.absoluteString

        try openExternalWalletApp(wcUrl: wcUrl)
        
        return try await wcService.sign(message: message)
    }
    
    func switchNetworkToMumbai() async -> Void {
        let params = AddETHChainParams(
            chainId: Constants.MUMBAI_CHAIN_ID,
            chainName: "Mumbai Testnet",
            nativeCurrency: NativeCurrency(
                name: "MATIC",
                symbol: "MATIC",
                decimals: 18
            ),
            rpcUrls: ["https://matic-mumbai.chainstacklabs.com/"],
            blockExplorerUrls: ["https://mumbai.polygonscan.com/"],
            iconUrls: ["https://polygonscan.com/images/svg/brands/polygon.svg"]
        )

        guard let request = try? Request(
            url: wcService.wcUrl,
            method: "wallet_addEthereumChain",
            params: [params]
        ) else {
            print("ERROR WHILE REQUEST CREATION")
            return
        }
        
        try? wcService.client.send(request) { response in
            print(response)
        }

        try? openExternalWalletApp(wcUrl: wcService.session.url.absoluteString)
    }
    
    func disconnect() -> Void {
        let _ = try? wcService.disconnect()
    }
    
    private func openExternalWalletApp(wcUrl: String) throws -> Void {
        let encodedWcUrl = wcUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let formattedWcUrl = encodedWcUrl.replacingOccurrences(of: "=", with: "%3D").replacingOccurrences(of: "&", with: "%26")

        guard let walletLink = UserDefaults.standard.string(forKey: Constants.WC_WALLET_TYPE_KEY) else {
            throw WalletConnectErrors.missingWalletType
        }
        
        let deepLink = "\(walletLink)\(formattedWcUrl)"

        guard let url = URL(string: deepLink) else {
            throw WalletConnectErrors.invalidDeepLink
        }
        
        if (!UIApplication.shared.canOpenURL(url)) {
            throw WalletConnectErrors.invalidDeepLink
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension WalletViewModel: WalletConnectDelegate {
    func didUpdate() {}

    func failedToConnect() {
        DispatchQueue.main.async {
            self.wcStatus = .failed
        }
    }

    func didConnect() {
        DispatchQueue.main.async {
            self.wcStatus = .connected
        }
    }

    func didDisconnect() {
        DispatchQueue.main.async {
            self.wcStatus = .disconnected
        }
    }
}

struct AddETHChainParams: Codable {
    var chainId: String
    var chainName: String
    
    var nativeCurrency: NativeCurrency?
    
    var rpcUrls: [String]
    
    var blockExplorerUrls: [String]?
    var iconUrls: [String]?
}

struct NativeCurrency: Codable {
    var name: String
    var symbol: String
    var decimals: Int
}
