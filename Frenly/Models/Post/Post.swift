//
//  Post.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation

struct Post {
    var id = 0
    var lensId = ""
    
    var ownerAddress = ""
    var username = ""
    var avatar = ""
    
    var fromAddress = ""
    var toAddress = ""
    var contractAddress = ""
    var transactionHash = ""
    
    var transferType = ""
    
    var image = ""
    
    var scanLink = ""
    
    var isMirror = true
    var mirroredFrom = ""
    var mirrorDescription = ""
    
    var isLiked = false
    
    var totalLikes = 0
    var totalComments = 0
    var totalMirrors = 0
    
    var createdDate = Date()
    
    func getFormattedDate() -> String {
        let secondsFromGMT = TimeZone.current.secondsFromGMT()
        let localizedDate = createdDate + TimeInterval(secondsFromGMT)
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM, dd 'AT' HH:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        return formatter.string(from: localizedDate).uppercased()
    }
}
