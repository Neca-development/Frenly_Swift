//
//  ENSWebService.swift
//  Frenly
//
//  Created by Владислав on 16.11.2022.
//

import Foundation

class ENSWebService: WebService {
    static func getUserNameByAddress (walletAddress: String) async throws -> ApiResponse<String?> {
        guard let url = URL(string: "\(APP_URL)/ens/\(walletAddress)") else {
            throw NetworkErrors.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            throw NetworkErrors.noData
        }
        
        guard let response = try? JSONDecoder().decode(ApiResponse<String?>.self, from: data) else {
            throw NetworkErrors.decodingError
        }

        return response
    }
}
