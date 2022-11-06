//
//  Comment.swift
//  Frenly
//
//  Created by Владислав on 06.11.2022.
//

import Foundation

struct Comment {
    var id: String = ""
    
    var avatar: String = ""
    var username: String = ""
    
    var text: String = ""
    
    var createdAt: Date = Date()
    
    func getFormattedDate() -> String {
        let interval = Date().timeIntervalSinceReferenceDate - createdAt.timeIntervalSinceReferenceDate
        
        if (interval < 3600) {
            return "NOW"
        }
        
        // 24 hours
        if (interval < 86400) {
            return "\(Int(interval / 3600)) H"
        }
        
        // 30 days
        if (interval < 2592000) {
            return "\(Int(interval / 86400)) D"
        }
        
        // 12 months
        if (interval < 31560000) {
            return "\(Int(interval / 2629746)) M"
        }
        
        return "\(Int(interval / 31560000)) Y"
    }
}
