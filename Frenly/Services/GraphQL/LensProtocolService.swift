//
//  LensProtocolService.swift
//  Frenly
//
//  Created by Владислав on 02.11.2022.
//

import Foundation
import Apollo

import LensProtocol

class LensProtocolService {
    private static var apolloClient = ApolloClient(url: URL(string: Constants.LENS_URL)!)
    
    // AUTHORIZATION
    
    static func challenge(address: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in

            apolloClient.fetch(query: ChallengeQuery(address: address)) { result in
                guard let data = try? result.get().data else {
                    continuation.resume(throwing: GraphQLErrors.noChallengeReturned)
                    return
                }
                
                continuation.resume(returning: data.challenge.text)
            }
        }
    }
    
    
    static func authenticate(address: String, signature: String) async throws -> JWTPair {
        try await withCheckedThrowingContinuation { continuation in
            
            apolloClient.perform(mutation: AuthenticateMutation(address: address, signature: signature)) { result in
                guard let data = try? result.get().data else {
                    continuation.resume(throwing: GraphQLErrors.unauthorized)
                    return
                }
                
                continuation.resume(
                    returning: JWTPair(
                        accessToken: data.authenticate.accessToken,
                        refreshToken: data.authenticate.refreshToken
                    ))
            }
        }
    }
    
    static func refreshTokens() async throws -> JWTPair {
        try await withCheckedThrowingContinuation { continuation in
            
            guard let refreshToken = LensTokenHelper.readRefreshToken() else {
                continuation.resume(throwing: GraphQLErrors.unauthorized)
                return
            }
            
            apolloClient.perform(mutation: RefreshMutation(token: refreshToken)) { result in               
                guard let data = try? result.get().data else {
                    continuation.resume(throwing: GraphQLErrors.unauthorized)
                    return
                }
                
                continuation.resume(
                    returning: JWTPair(
                        accessToken: data.refresh.accessToken,
                        refreshToken: data.refresh.refreshToken
                    ))
            }
        }
    }
    
    // POSTS
    
    static func getFeedPostInfo(publicationIds: [String]) async -> [FeedPostInfo] {
        await withCheckedContinuation { continuation in

            apolloClient.fetch(query: FeedPostsInfoQuery(publicationIds: .some(publicationIds))) { result in
                var posts: [FeedPostInfo] = []
                
                guard let data = try? result.get().data else {
                    continuation.resume(returning: posts)
                    return
                }
                
                for i in 0..<data.publications.items.count {
                    if (data.publications.items[i].asPost?.id != nil) {
                        posts.append(FeedPostInfo(
                            id: data.publications.items[i].asPost!.id,
                            ownerWalletAddress: data.publications.items[i].asPost!.profile.ownedBy,
                            isMirror: false,
                            mirrorFrom: "",
                            totalAmountOfComments: data.publications.items[i].asPost!.stats.totalAmountOfComments,
                            totalUpvotes: data.publications.items[i].asPost!.stats.totalUpvotes,
                            totalAmountOfMirrors: data.publications.items[i].asPost!.stats.totalAmountOfMirrors
                        ))
                    } else {
                        posts.append(FeedPostInfo(
                            id: data.publications.items[i].asMirror!.id,
                            ownerWalletAddress: data.publications.items[i].asMirror!.profile.ownedBy,
                            isMirror: true,
                            mirrorFrom: data.publications.items[i].asMirror!.mirrorOf.asPost!.profile.ownedBy,
                            totalAmountOfComments: data.publications.items[i].asMirror!.stats.totalAmountOfComments,
                            totalUpvotes: data.publications.items[i].asMirror!.stats.totalUpvotes,
                            totalAmountOfMirrors: data.publications.items[i].asMirror!.stats.totalAmountOfMirrors
                        ))
                    }
                }
                
                continuation.resume(returning: posts)
            }
        }
    }
    
    // Response Types
    struct JWTPair {
        var accessToken: String
        var refreshToken: String
    }
    
    struct FeedPostInfo {
        var id: String
        var ownerWalletAddress: String
        
        var isMirror: Bool
        var mirrorFrom: String
        
        var totalAmountOfComments: Int
        var totalUpvotes: Int
        var totalAmountOfMirrors: Int
    }
}
