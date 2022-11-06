//
//  NetworkErrors.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation

enum NetworkErrors: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case intenalServerError
    case unauthorized
}
