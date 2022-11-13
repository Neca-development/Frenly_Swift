//
//  FeedWebService.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation

class FeedWebService: WebService {
    static func getFilteredNftPosts (take: Int, skip: Int) async throws -> ApiResponse<[NftPostResponse]> {
        guard let url = URL(string: "\(APP_URL)/content/filtered?take=\(take)&skip=\(skip)") else {
            throw NetworkErrors.invalidURL
        }
        
        try await validateTokens()
        
        guard let accessToken = AuthTokenHelper.readAccessToken() else { throw NetworkErrors.noData }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        guard let response = try? JSONCoder().decoder.decode(ApiResponse<[NftPostResponse]>.self, from: data) else {
            throw NetworkErrors.decodingError
        }

        return response
    }
    
    static func getDraftsNftPosts () async throws -> ApiResponse<[NftPostResponse]> {
        guard let url = URL(string: "\(APP_URL)/content/unpublished") else {
            throw NetworkErrors.invalidURL
        }
        
        try await validateTokens()
        
        guard let accessToken = AuthTokenHelper.readAccessToken() else { throw NetworkErrors.noData }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        guard let response = try? JSONCoder().decoder.decode(ApiResponse<[NftPostResponse]>.self, from: data) else {
            throw NetworkErrors.decodingError
        }

        return response
    }
    
    static func getOwnedPostMetadataURL (contentId: Int) async throws -> ApiResponse<String> {
        guard let url = URL(string: "\(APP_URL)/content/\(contentId)/metadata") else {
            throw NetworkErrors.invalidURL
        }
        
        try await validateTokens()
        
        guard let accessToken = AuthTokenHelper.readAccessToken() else { throw NetworkErrors.noData }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        guard let response = try? JSONCoder().decoder.decode(ApiResponse<String>.self, from: data) else {
            throw NetworkErrors.decodingError
        }

        return response
    }
    
    static func getCommentsMetadataURL (lensId: String, comment: String) async throws -> ApiResponse<String> {
        guard let url = URL(string: "\(APP_URL)/content/comment/metadata") else {
            throw NetworkErrors.invalidURL
        }
        
        try await validateTokens()
        
        guard let accessToken = AuthTokenHelper.readAccessToken() else { throw NetworkErrors.noData }
        var request = URLRequest(url: url)
        
        let body = CommentMetadataBody(lensId: lensId, comment: comment)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        guard let response = try? JSONCoder().decoder.decode(ApiResponse<String>.self, from: data) else {
            throw NetworkErrors.decodingError
        }

        return response
    }
    
    static func bindContentWithLensId (contentId: Int, lensId: String) async throws -> Int {
        guard let url = URL(string: "\(APP_URL)/content/\(contentId)/\(lensId)") else {
            throw NetworkErrors.invalidURL
        }
        
        try await validateTokens()
        
        guard let accessToken = AuthTokenHelper.readAccessToken() else { throw NetworkErrors.noData }
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        guard let (_, response) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        let httpResponse = response as? HTTPURLResponse
        guard let statusCode = httpResponse?.statusCode else {
            throw NetworkErrors.intenalServerError
        }
        
        return statusCode
    }
    
    static func publishContent (contentId: Int) async throws -> Int {
        guard let url = URL(string: "\(APP_URL)/content/\(contentId)") else {
            throw NetworkErrors.invalidURL
        }
        
        try await validateTokens()
        
        guard let accessToken = AuthTokenHelper.readAccessToken() else { throw NetworkErrors.noData }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        guard let (_, response) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        let httpResponse = response as? HTTPURLResponse
        guard let statusCode = httpResponse?.statusCode else {
            throw NetworkErrors.intenalServerError
        }
        
        return statusCode
    }
    
    static func removeContent (contentId: Int) async throws -> Int {
        guard let url = URL(string: "\(APP_URL)/content/\(contentId)") else {
            throw NetworkErrors.invalidURL
        }
        
        try await validateTokens()
        
        guard let accessToken = AuthTokenHelper.readAccessToken() else { throw NetworkErrors.noData }
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        guard let (_, response) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        let httpResponse = response as? HTTPURLResponse
        guard let statusCode = httpResponse?.statusCode else {
            throw NetworkErrors.intenalServerError
        }
        
        return statusCode
    }
    
    // Responses
    
    struct NftPostResponse: Codable {
        var id: Int = 0

        var fromAddress: String = ""

        var toAddress: String = ""

        var tokenId: String = ""

        var blockchainType: Int = 0

        var contractAddress: String = ""

        var tokenUri: String = ""

        var image: String? = ""

        var transactionHash: String = ""

        var lensId: String? = ""

        var isMirror: Bool = false

        var mirrorDescription: String? = ""

        var creationDate: Date = Date()

        var transferType: String = ""
    }
    
    // Request
    
    struct CommentMetadataBody: Codable {
        var lensId: String
        
        var comment: String
    }
}
