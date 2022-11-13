//
//  WalletConnect.swift
//  Frenly
//
//  Created by Владислав on 20.10.2022.
//

import Foundation
import WalletConnectSwift

protocol WalletConnectDelegate: AnyObject {
    func failedToConnect()
    func didConnect()
    func didDisconnect()
    func didUpdate()
}

final class WalletConnectService {
    var session: Session!
    var client: Client!
    var wcUrl: WCURL!

    private var delegate: WalletConnectDelegate

    init(delegate: WalletConnectDelegate) {
        self.delegate = delegate
    }

    func connect(title: String, description: String, icons: [URL] = []) -> String {
        // gnosis wc bridge: https://safe-walletconnect.gnosis.io/
        // test bridge with latest protocol version: https://bridge.walletconnect.org

        let bridgeURL = URL(string: "https://bridge.walletconnect.org")!
        let clientURL = URL(string: "https://gm.frenly.cc")!
        
        let randmoKey = try! UtilsService.Random.get32BytesHex()

        let wcUrl = WCURL(
            topic: UUID().uuidString,
            bridgeURL: bridgeURL,
            key: randmoKey
        )

        let clientMeta = Session.ClientMeta(
            name: title,
            description: description,
            icons: icons,
            url: clientURL
        )

        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
    
        client = Client(delegate: self, dAppInfo: dAppInfo)
        try! client.connect(to: wcUrl)
        
        return wcUrl.absoluteString
    }

    func tryReconnect() -> ReconnectStatus {
        do {
            guard let oldSessionObject = try? UserDefaults.standard.getObject(
                forKey: Constants.WC_SESSION_KEY,
                castTo: Session.self
            ) else {
                return .failed
            }
            
            client = Client(delegate: self, dAppInfo: oldSessionObject.dAppInfo)
            try client.reconnect(to: oldSessionObject)
            
            return .success
        } catch {
            return .failed
        }
    }
    
    func disconnect() throws -> Void {
        guard let session = session else { return }

        try client.disconnect(from: session)
    }
    
    func sign(message: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            guard let accounts = self.session?.walletInfo?.accounts, let wallet = accounts.first else { return }
            
            do {
                try self.client.personal_sign(
                    url: self.session.url,
                    message: message,
                    account: wallet
                ) { response in
                    guard let responseHash = try? response.result(as: String.self) else { return }
                    continuation.resume(with: .success(responseHash))
                }
            } catch {
                continuation.resume(with: .failure(error))
            }
        }
    }
    
    func signTypedData(message: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            guard let accounts = self.session?.walletInfo?.accounts, let wallet = accounts.first else { return }
            
            do {
                try self.client.eth_signTypedData(
                    url: self.session.url,
                    account: wallet,
                    message: message
                ) { response in
                    guard let responseHash = try? response.result(as: String.self) else { return }
                    continuation.resume(with: .success(responseHash))
                }
            } catch {
                continuation.resume(with: .failure(error))
            }
        }
    }
    
    
    enum ReconnectStatus {
        case success
        case failed
    }
}

extension WalletConnectService: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
        delegate.failedToConnect()
    }

    func client(_ client: Client, didConnect url: WCURL) {
        self.wcUrl = url
    }

    func client(_ client: Client, didConnect session: Session) {
        self.session = session
        delegate.didConnect()

        try? UserDefaults.standard.setObject(session, forKey: Constants.WC_SESSION_KEY)
    }

    func client(_ client: Client, didDisconnect session: Session) {
        delegate.didDisconnect()
        
        UserDefaults.standard.removeObject(forKey: Constants.WC_SESSION_KEY)
    }

    func client(_ client: Client, didUpdate session: Session) {
        delegate.didUpdate()
    }
}
