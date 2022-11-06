//
//  UserWebService.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation

class UserWebService: WebService {
    static func getUserInfo (walletAddress: String) async throws -> ApiResponse<UserResponse> {
        guard let url = URL(string: "\(APP_URL)/user/\(walletAddress)") else {
            throw NetworkErrors.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        guard let response = try? JSONDecoder().decode(ApiResponse<UserResponse>.self, from: data) else {
            throw NetworkErrors.decodingError
        }

        return response
    }
    
    static func uploadAvatart (avatar: Media) async throws -> ApiResponse<String?> {
        guard let url = URL(string: "\(APP_URL)/user/avatar") else {
            throw NetworkErrors.invalidURL
        }
        
        try await validateTokens()
        
        guard let accessToken = AuthTokenHelper.readAccessToken() else { throw NetworkErrors.noData }
        var request = URLRequest(url: url)
        
        let boundary = UtilsService.MediaUtil.generateBoundary()
        let dataBody = UtilsService.MediaUtil.createDataBody(media: [avatar], boundary: boundary)
        
        request.httpMethod = "PUT"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = dataBody
    
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        guard let response = try? JSONDecoder().decode(ApiResponse<String?>.self, from: data) else {
            throw NetworkErrors.decodingError
        }

        return response
    }
    
    static func updateUserInfo (username: String, description: String) async throws -> ApiResponse<String?> {
        guard let url = URL(string: "\(APP_URL)/user") else {
            throw NetworkErrors.invalidURL
        }
        
        try await validateTokens()
        guard let accessToken = AuthTokenHelper.readAccessToken() else { throw NetworkErrors.noData }
        
        let body = UpdateUserRequest(username: username, description: description)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
    
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        guard let response = try? JSONDecoder().decode(ApiResponse<String?>.self, from: data) else {
            throw NetworkErrors.decodingError
        }

        return response
    }
    
    // Requests
    
    struct UpdateUserRequest: Codable {
        var username: String
        var description: String
    }
    
    // Responses
    
    struct UserResponse: Codable {
        var username: String?
        var avatar: String?
        var description: String?
    }
}
