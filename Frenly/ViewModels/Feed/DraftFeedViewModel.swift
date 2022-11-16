//
//  DraftFeedViewModel.swift
//  Frenly
//
//  Created by Владислав on 06.11.2022.
//

import Foundation

@MainActor
class DraftFeedViewModel: ObservableObject {
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
        
        guard let response = try? await FeedWebService.getDraftsNftPosts(take: take, skip: skip) else {
            return
        }
        
        
        if (response.data.count == 0) {
            isEndOfPage = true
            isFetching = false
            return
        }

        for i in 0..<response.data.count {
            let scanLink = "https://etherscan.io/tx/\(response.data[i].transactionHash)"
            
            posts.append(Post(
                id: response.data[i].id,
                fromAddress: response.data[i].fromAddress,
                toAddress: response.data[i].toAddress,
                contractAddress: response.data[i].contractAddress,
                transactionHash: response.data[i].transactionHash,
                transferType: response.data[i].transferType,
                image: response.data[i].image ?? "",
                scanLink: scanLink,
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
        
        posts.removeAll()
        
        isEndOfPage = false
        await fetchPosts()
    }
}
