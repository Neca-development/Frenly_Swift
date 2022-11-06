//
//  AuthTokensHelper.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation

final class AuthTokenHelper {
    private static let applicationAccount = "application"
    
    static func saveAccessToken(_ token: String) -> Void {
        let data = Data(token.utf8)

        KeychainHelper.standard.save(
            data,
            service: Constants.ACCESS_TOKEN_KEY,
            account: applicationAccount
        )
    }
    
    static func saveRefreshToken(_ token: String) -> Void {
        let data = Data(token.utf8)

        KeychainHelper.standard.save(
            data,
            service: Constants.REFRESH_TOKEN_KEY,
            account: applicationAccount
        )
    }
    
    static func readAccessToken() -> String? {
        guard let data = KeychainHelper.standard.read(
            service: Constants.ACCESS_TOKEN_KEY,
            account: applicationAccount
        ) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
    
    static func readRefreshToken() -> String? {
        guard let data = KeychainHelper.standard.read(
            service: Constants.REFRESH_TOKEN_KEY,
            account: applicationAccount
        ) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
    
    static func clearTokens() -> Void {
        KeychainHelper.standard.delete(
            service: Constants.ACCESS_TOKEN_KEY,
            account: applicationAccount
        )
        
        KeychainHelper.standard.delete(
            service: Constants.REFRESH_TOKEN_KEY,
            account: applicationAccount
        )
    }
}
