//
//  LoginViewModel.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var status: AuthorizationStatus = .unauthorized
    
    private let webService = AuthWebService()
    
    func getUserNonce(walletAddress: String) async throws -> Int {
        let response = try await webService.getUsersNonce(walletAddress: walletAddress)
        
        return response.data.nonce
    }
    
    func authorizeWithSignature(walletAddress: String, signature: String) async throws -> Void {
        let response = try await webService.validateSignature(walletAddress: walletAddress, signature: signature)
        
        AuthTokenHelper.saveAccessToken(response.data.accessToken)
        AuthTokenHelper.saveRefreshToken(response.data.refreshToken)
        
        status = .authorized
    }
    
    func refreshTokens() async throws -> Void {
        let response = try await webService.refreshToken()

        AuthTokenHelper.saveAccessToken(response.data.accessToken)
        AuthTokenHelper.saveRefreshToken(response.data.refreshToken)
    }
    
    enum AuthorizationStatus {
        case authorized
        case unauthorized
    }
}
