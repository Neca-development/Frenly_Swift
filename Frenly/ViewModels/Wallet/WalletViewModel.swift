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
    
    public init() {
        wcService = WalletConnectService(delegate: self)
        
        let status = wcService.tryReconnect()

        if (status == .success) {
            wcStatus = .connected
        }
    }
     
    func connectWallet(walletType: WalletType) async -> Void {
        let wcUrl = wcService.connect(title: "Frenly", description: "Frenly App")
        let encodedWcUrl = wcUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let formattedWcUrl = encodedWcUrl.replacingOccurrences(of: "=", with: "%3D").replacingOccurrences(of: "&", with: "%26")

        let deepLink =  "\(walletType.rawValue)\(formattedWcUrl)"

        guard let url = URL(string: deepLink) else {
            wcStatus = .failed
            return
        }
        
        if (!UIApplication.shared.canOpenURL(url)) {
            wcStatus = .failed
            return
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
