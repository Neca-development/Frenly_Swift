//
//  FeedViewModel.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation
import SwiftUI

import Apollo

@MainActor
class TotalFeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    @Published var isFetching = false
    @Published var isEndOfPage = false
    
    private var take = 5;
    private var skip = 0;
    
    func fetchPosts() async -> Void {
        if (isEndOfPage || isFetching) {
            return
        }
        
        isFetching = true

        guard let response = try? await FeedWebService.getFilteredNftPosts(take: take, skip: skip) else {
            isFetching = false
            return
        }
        
        if (response.data.count == 0) {
            isEndOfPage = true
            isFetching = false
            return
        }
        
        let backendPosts = response.data.filter { $0.lensId != nil }
        let lensIds = backendPosts.map { $0.lensId! }
        
        let lensPosts = await LensProtocolService.getFeedPostInfo(publicationIds: lensIds)

        for i in 0..<backendPosts.count {
            guard let lensPost = lensPosts.first(where: { $0.id == backendPosts[i].lensId }) else {
                continue
            }
            
            let scanLink = "https://etherscan.io/tx/\(backendPosts[i].transactionHash)"
            
            let postOwner = try? await UserWebService.getUserInfo(walletAddress: lensPost.ownerWalletAddress)
            let mirroredFrom = try? await UserWebService.getUserInfo(walletAddress: lensPost.mirrorFrom)

            posts.append(Post(
                id: backendPosts[i].id,
                lensId: backendPosts[i].lensId!,
                ownerAddress: lensPost.ownerWalletAddress,
                username: postOwner?.data.username ?? UtilsService.User.nameFromWalletAddress(walletAddress: lensPost.ownerWalletAddress),
                avatar: postOwner?.data.avatar ?? "",
                fromAddress: backendPosts[i].fromAddress,
                toAddress: backendPosts[i].toAddress,
                contractAddress: backendPosts[i].contractAddress,
                transactionHash: backendPosts[i].transactionHash,
                transferType: backendPosts[i].transferType,
                image: backendPosts[i].image ?? "",
                scanLink: scanLink,
                isMirror: lensPost.isMirror,
                mirroredFrom: mirroredFrom?.data.username ?? UtilsService.User.nameFromWalletAddress(walletAddress: lensPost.mirrorFrom),
                mirrorDescription: backendPosts[i].mirrorDescription ?? "",
                totalLikes: lensPost.totalUpvotes,
                totalComments: lensPost.totalAmountOfComments,
                totalMirrors: lensPost.totalAmountOfMirrors,
                createdDate: response.data[i].creationDate
            ))
        }
        
        skip += take
        isFetching = false
    }
    
    func refreshPosts() async -> Void {
        if (isFetching) {
            return
        }
        
        take = 5
        skip = 0
        
        isEndOfPage = false
        
        posts = []
        
        await fetchPosts()
    }
}
