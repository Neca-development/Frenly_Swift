//
//  ContentView.swift
//  Frenly
//
//  Created by Владислав on 20.10.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var wallet = WalletViewModel()
    
    var body: some View {
        if (wallet.wcStatus == .disconnected) {
            LoginView()
                .environmentObject(wallet)
        }
        
        if (wallet.wcStatus == .connected) {
            TotalFeedView()
                .environmentObject(wallet)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
