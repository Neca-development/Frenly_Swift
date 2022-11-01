//
//  AuthWebService.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation

class AuthWebService: WebService {
    func getUsersNonce (walletAddress: String) async throws -> ApiResponse<NonceResponse> {
        guard let url = URL(string: "\(APP_URL)/auth/\(walletAddress)/nonce") else {
            throw NetworkErrors.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        guard let response = try? JSONDecoder().decode(ApiResponse<NonceResponse>.self, from: data) else {
            throw NetworkErrors.decodingError
        }

        return response
    }
    
    func validateSignature (walletAddress: String, signature: String) async throws -> ApiResponse<JWTPairResponse> {
        guard let url = URL(string: "\(APP_URL)/auth/\(walletAddress)/signature") else {
            throw NetworkErrors.invalidURL
        }
        
        let body = ValidateSignatureBody(signature: signature)
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
    
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        guard let response = try? JSONDecoder().decode(ApiResponse<JWTPairResponse>.self, from: data) else {
            throw NetworkErrors.decodingError
        }

        return response
    }
    
    func refreshToken () async throws -> ApiResponse<JWTPairResponse> {
        guard let url = URL(string: "\(APP_URL)/auth/refresh-token") else {
            throw NetworkErrors.invalidURL
        }
        
        guard let accessToken = AuthTokenHelper.readAccessToken() else { throw NetworkErrors.noData }
        guard let refreshToken = AuthTokenHelper.readRefreshToken() else { throw NetworkErrors.noData }
        
        let body = RefreshTokenBody(refreshToken: refreshToken)
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
    
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        guard let response = try? JSONDecoder().decode(ApiResponse<JWTPairResponse>.self, from: data) else {
            throw NetworkErrors.decodingError
        }

        return response
    }
    
    // Requests
    struct ValidateSignatureBody: Codable {
        let signature: String
    }
    
    struct RefreshTokenBody: Codable {
        let refreshToken: String
    }
    
    // Responses

    struct NonceResponse: Codable {
        let nonce: Int
    }
    
    struct JWTPairResponse: Codable {
        let accessToken: String

        let refreshToken: String
    }
}
