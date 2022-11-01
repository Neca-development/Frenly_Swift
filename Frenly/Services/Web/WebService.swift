//
//  WebService.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation

class WebService {
    let APP_URL = Constants.SERVER_URL
    
    class ApiResponse<T : Codable> : Codable {
        let data: T
        let error: String
        let status: Int
    }
}
