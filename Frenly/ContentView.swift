//
//  ContentView.swift
//  Frenly
//
//  Created by Владислав on 20.10.2022.
//

import SwiftUI
import JWTDecode

struct ContentView: View {
    @StateObject private var login = LoginViewModel()
    @StateObject private var wallet = WalletViewModel()
    
    var body: some View {
        ZStack {
//            if (login.status == .unauthorized || wallet.wcStatus == .failed || wallet.wcStatus == .disconnected) {
//                LoginView()
//                    .environmentObject(login)
//                    .environmentObject(wallet)
//            }
//
//            if (login.status == .authorized && wallet.wcStatus == .connected) {
                TotalFeedView()
                    .environmentObject(wallet)
//            }

        }
        .onAppear() {
//            tryConnectWithDefaults()
        }
    }
    
    func tryConnectWithDefaults() -> Void {
        let status = wallet.reconnect()

        if (status == .success) {
            wallet.wcStatus = .connected
        }
        
        guard let accessToken = AuthTokenHelper.readAccessToken() else { return }
        guard let decodedAccess = try? decode(jwt: accessToken) else { return }

        if !decodedAccess.expired {
            login.status = .authorized
            return
        }
        
        Task {
            guard let _ = try? await login.refreshTokens() else { return }
                
            login.status = .authorized
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
