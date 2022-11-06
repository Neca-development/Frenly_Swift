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
    
    func fetchPosts() async -> Void {
        guard let response = try? await FeedWebService.getDraftsNftPosts() else {
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
    }
}
