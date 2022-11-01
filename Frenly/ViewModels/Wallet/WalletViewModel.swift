//
//  WalletViewModel.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import Foundation
import SwiftUI

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
        wcStatus = .failed
    }

    func didConnect() {
        DispatchQueue.main.async {
            self.wcStatus = .connected
        }
    }

    func didDisconnect() {
        wcStatus = .disconnected
    }
}
