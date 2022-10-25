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

    private let sessionKey = "frenly"
    private var delegate: WalletConnectDelegate

    init(delegate: WalletConnectDelegate) {
        self.delegate = delegate
    }

    func connect(title: String, description: String, icons: [URL] = []) -> String {
        // gnosis wc bridge: https://safe-walletconnect.gnosis.io/
        // test bridge with latest protocol version: https://bridge.walletconnect.org

        let bridgeURL = URL(string: "https://safe-walletconnect.gnosis.io/")!
        let clientURL = URL(string: "https://safe.gnosis.io")!
        
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
            guard let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data else {
                return .failed
            }
            
            let session = try JSONDecoder().decode(Session.self, from: oldSessionObject)
            
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try client.reconnect(to: session)
            
            return .success
        } catch {
            return .failed
        }
    }
    
    func disconnect() throws -> Void {
        guard let session = session else { return }

        try client.disconnect(from: session)
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
        
        print("WC: ESTABLISHED SESSION")
        
        delegate.didConnect()
    }

    func client(_ client: Client, didDisconnect session: Session) {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        delegate.didDisconnect()
    }

    func client(_ client: Client, didUpdate session: Session) {
        delegate.didUpdate()
    }
}
