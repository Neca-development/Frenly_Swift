//
//  LoginViewModel.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var status: AuthorizationStatus = .inProgress
    
    func getUserNonce(walletAddress: String) async throws -> Int {
        let response = try await AuthWebService.getUsersNonce(walletAddress: walletAddress)
        
        return response.data.nonce
    }
    
    func authorizeWithBackendSignature(walletAddress: String, signature: String) async throws -> Void {
        let response = try await AuthWebService.validateSignature(walletAddress: walletAddress, signature: signature)
        
        AuthTokenHelper.saveAccessToken(response.data.accessToken)
        AuthTokenHelper.saveRefreshToken(response.data.refreshToken)
    }
    
    func authorizeWithLensSignature(walletAddress: String, signature: String) async throws -> Void {
        let JWTPair = try await LensProtocolService.authenticate(address: walletAddress, signature: signature)
        
        LensTokenHelper.saveAccessToken(JWTPair.accessToken)
        LensTokenHelper.saveRefreshToken(JWTPair.refreshToken)
    }
    
    static func refreshTokens() async throws -> JWTPair {
        let response = try await AuthWebService.refreshToken()

        AuthTokenHelper.saveAccessToken(response.data.accessToken)
        AuthTokenHelper.saveRefreshToken(response.data.refreshToken)
            
        return JWTPair(
            accessToken: response.data.accessToken,
            refreshToken: response.data.refreshToken
        )
    }
    
    static func refreshLensTokens() async throws -> JWTPair {
        let response = try await LensProtocolService.refreshTokens()
        
        LensTokenHelper.saveAccessToken(response.accessToken)
        LensTokenHelper.saveRefreshToken(response.refreshToken)
        
        return JWTPair(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
    }
    
    enum AuthorizationStatus {
        case authorized
        case unauthorized
        case inProgress
    }
    
    struct JWTPair {
        var accessToken: String
        var refreshToken: String
    }
}
