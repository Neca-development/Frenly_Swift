//
//  TwitterUtil.swift
//  Frenly
//
//  Created by Владислав on 15.11.2022.
//

import Foundation
import SwiftUI

extension UtilsService {
    class TwitterUtil {
        static func redirectToTwitter(post: Post) -> Void {
            let imageUrl = "\(Constants.SERVER_URL)/token-images/\(post.image)"
            var text = "I use 👀 Frenly "
            
            if (post.fromAddress == Constants.ETH_NULL_ADDRESS) {
                text += "🎉 minted a new NFT from\n\(post.contractAddress)\n"
            }
            
            if (post.fromAddress != Constants.ETH_NULL_ADDRESS) {
                text += "📤 \(post.transferType == "SEND" ? "sent" : "recieved") NFT \(post.transferType == "SEND" ? "to" : "from")\n"
                text += post.transferType == "SEND" ? post.fromAddress : post.toAddress
                text += "\n"
            }
            
            text += "Find and post by gm.frenly.cc\n"
            text += post.scanLink
            
            let link = "https://twitter.com/intent/tweet?hashtags=Frenly,LENS&url=\(imageUrl)&text=\(text)"
            guard let formattedUrl = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return
            }
            
            print(formattedUrl)
            
            guard let url = URL(string: formattedUrl) else {
                return
            }
            
            print(formattedUrl)
            
            if (!UIApplication.shared.canOpenURL(url)) {
                return
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
