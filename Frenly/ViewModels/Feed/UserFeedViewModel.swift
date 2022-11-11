//
//  UserFeedViewModel.swift
//  Frenly
//
//  Created by Владислав on 11.11.2022.
//

import Foundation

@MainActor
class UserFeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    @Published var isFetching = false
    @Published var isEndOfPage = false
    
    @Published var cursor: String? = nil
    
    func fetchPosts(walletAddress: String) async -> Void {
        if (isFetching || isEndOfPage) {
            return
        }
        
        isFetching = true
        
        guard let lensId = await SmartContractService().lensIdByWalletAddress(walletAddress: walletAddress) else {
            isFetching = false
            return
        }
        
        let response = await LensProtocolService.getUsersPostById(profileId: lensId, cursor: cursor)
        
        let posts = response.posts
        cursor = response.cursor
        
        if (cursor == nil) {
            isEndOfPage = true
        }
        
        for i in 0..<posts.count {
            let scanLink = "https://etherscan.io/tx/\(posts[i].transactionHash)"
            
            let postOwner = try? await UserWebService.getUserInfo(walletAddress: walletAddress)
            let mirroredFrom = try? await UserWebService.getUserInfo(walletAddress: posts[i].mirrorFrom)

            self.posts.append(Post(
                lensId: posts[i].id,
                username: postOwner?.data.username ?? UtilsService.User.nameFromWalletAddress(walletAddress: walletAddress),
                avatar: postOwner?.data.avatar ?? "",
                fromAddress: posts[i].fromAddress,
                toAddress: posts[i].toAddress,
                contractAddress: posts[i].scAddress,
                transactionHash: posts[i].transactionHash,
                transferType: posts[i].transferType,
                image: posts[i].image,
                scanLink: scanLink,
                isMirror: posts[i].isMirror,
                mirroredFrom: mirroredFrom?.data.username ?? UtilsService.User.nameFromWalletAddress(walletAddress: posts[i].mirrorFrom),
                totalLikes: posts[i].totalUpvotes,
                totalComments: posts[i].totalAmountOfComments,
                totalMirrors: posts[i].totalAmountOfMirrors,
                createdDate: posts[i].creationDate
            ))
        }
        
        isFetching = false
    }
}
