//
//  ContentView.swift
//  Frenly
//
//  Created by Владислав on 20.10.2022.
//

import SwiftUI
import JWTDecode

struct ContentView: View {
    @StateObject private var auth = AuthViewModel()
    @StateObject private var wallet = WalletViewModel()
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            if (auth.status == .unauthorized || wallet.wcStatus != .connected) {
                LoginView()
                    .environmentObject(auth)
                    .environmentObject(wallet)
                    .animation(.easeInOut(duration: 0.4), value: auth.status)
            }

            if (auth.status == .authorized) {
                TotalFeedView()
                    .environmentObject(auth)
                    .environmentObject(wallet)
                    .animation(.easeInOut(duration: 0.4), value: auth.status)
            }
            
            if (auth.status == .inProgress) {
                Color.appBackground.ignoresSafeArea()

                Image("Image_Eyes")
                    .resizable()
                    .frame(
                        width: 200,
                        height: 200
                    )
            }
        }
        .onAppear() {
            tryConnectWithDefaults()
        }
    }
    
    func tryConnectWithDefaults() -> Void {
        let status = wallet.reconnect()

        if (status == .success) {
            wallet.wcStatus = .connected
        }
        
        Task {
            guard let _ = try? await AuthViewModel.refreshTokens() else {
                auth.status = .unauthorized
                return
            }
            
            guard let _ = try? await AuthViewModel.refreshLensTokens() else {
                auth.status = .unauthorized
                return
            }
                
            auth.status = .authorized
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
