//
//  LoginView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var login: LoginViewModel
    @EnvironmentObject private var wallet: WalletViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("Image_Eyes")
                .padding(.top, 80)
            
            Spacer()
            
            Text("frenly")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .padding(.bottom)
            
            Text("web3 social network—follow your frens to see what are they doing on-chain")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.foregroundSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Button {
                Task {
                    if (wallet.wcStatus != .connected) {
                        await wallet.connectWallet(walletType: .metaMask)
                    } else {
                        await authorize()
                    }
                }
            } label: {
                Text("CONNECT WALLET")
                    .font(.system(size: 20, weight: .regular, design: .rounded))
                    .frame(
                        width: UIScreen.main.bounds.width * 0.9,
                        height: 45
                    )
                    .background(Color.lightBlue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
            }
            .onChange(of: wallet.wcStatus) { status in
                if (status == .connected) {
                    Task { await authorize() }
                }
            }
            
            Spacer()
        }
    }
    
    private func authorize() async -> Void {
        do {
            guard let walletAddress = wallet.walletAddress else { return }
            
            let nonce = try await login.getUserNonce(walletAddress: walletAddress)
            let message = "Nonce: \(nonce)"
            
            let signature = try await wallet.sign(message: message)
            
            try await login.authorizeWithSignature(walletAddress: walletAddress, signature: signature)
        } catch {
            wallet.wcStatus = .failed
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(WalletViewModel())
    }
}
