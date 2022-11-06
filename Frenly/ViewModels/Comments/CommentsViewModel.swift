//
//  CommentsViewModel.swift
//  Frenly
//
//  Created by Владислав on 06.11.2022.
//

import Foundation

@MainActor
class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    
    func fetchComments(lensId: String) async -> Void {
        let lensComments = await LensProtocolService.getCommentsByPostId(postId: lensId)
        var unorderedComments: [Comment] = []
        
        for i in 0..<lensComments.count {
            let postOwner = try? await UserWebService.getUserInfo(walletAddress: lensComments[i].walletAddress)
            
            unorderedComments.append(Comment(
                id: lensComments[i].id,
                avatar: postOwner?.data.avatar ?? "",
                username: postOwner?.data.username ?? UtilsService.User.nameFromWalletAddress(walletAddress: lensComments[i].walletAddress),
                text: lensComments[i].text,
                createdAt: lensComments[i].creationDate
            ))
        }
        
        comments = unorderedComments.sorted() {
            $0.createdAt > $1.createdAt
        }
    }
}
