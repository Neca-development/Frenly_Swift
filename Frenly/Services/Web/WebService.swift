//
//  WebService.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation
import JWTDecode

class WebService {
    static let APP_URL = Constants.SERVER_URL
    
    static func validateTokens() async throws -> Void {
        guard let accessToken = AuthTokenHelper.readAccessToken() else { throw NetworkErrors.unauthorized }
        
        guard let token = try? decode(jwt: accessToken) else { throw NetworkErrors.unauthorized }
        
        if (token.expired) {
            guard let _ = try? await AuthWebService.refreshToken() else { throw NetworkErrors.unauthorized }
        }
    }
    
    class ApiResponse<T : Codable> : Codable {
        var data: T
        var error: String
        var status: Int
    }
}
