//
//  JSONCoder.swift
//  Frenly
//
//  Created by Владислав on 03.11.2022.
//

import Foundation

class JSONCoder {
    let dateFormatter: DateFormatter = DateFormatter()

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            if let date = self.dateFormatter.date(from: dateString) {
                return date
            }
            
            self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            if let date = self.dateFormatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container,
                debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }
    
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        encoder.dateEncodingStrategy = .formatted(self.dateFormatter)
        return encoder
    }
}
