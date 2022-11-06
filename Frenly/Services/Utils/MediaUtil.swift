//
//  MediaUtil.swift
//  Frenly
//
//  Created by Владислав on 03.11.2022.
//

import Foundation

extension UtilsService {
    class MediaUtil {
        static func createDataBody(media: [Media]?, boundary: String) -> Data {
           let lineBreak = "\r\n"
           var body = Data()

           if let media = media {
               
              for photo in media {
                 body.append("--\(boundary + lineBreak)")
                 body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                 body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                 body.append(photo.data)
                 body.append(lineBreak)
              }
           }
            
           body.append("--\(boundary)--\(lineBreak)")
           return body
        }
        
        static func generateBoundary() -> String {
           return "Boundary-\(NSUUID().uuidString)"
        }
    }
}
