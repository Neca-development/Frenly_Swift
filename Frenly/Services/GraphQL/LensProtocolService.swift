//
//  LensProtocolService.swift
//  Frenly
//
//  Created by Владислав on 02.11.2022.
//

import Foundation
import Apollo
import ApolloAPI

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
    
    static func getUsersPostById(profileId: String, cursor: String? = nil) async -> UserPostsResponse {
        await withCheckedContinuation { continuation in
            let gqlCursor: GraphQLNullable<String> = cursor == nil ? .null : .some(cursor!)
            
            apolloClient.fetch(query: UserPostsByLensIdQuery(profileId: profileId, cursor: gqlCursor)) { result in
                var posts: [UserPostInfo] = []
                
                guard let data = try? result.get().data else {
                    continuation.resume(returning: UserPostsResponse(posts: posts, cursor: nil))
                    return
                }
                
                let cursor = data.publications.pageInfo.next
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                
                for i in 0..<data.publications.items.count {
                    if (data.publications.items[i].asPost?.id != nil) {
                        let post = data.publications.items[i].asPost!
                        let createdAt = dateFormatter.date(from: post.createdAt)!
                        
                        posts.append(UserPostInfo(
                            id: post.id,
                            isMirror: false,
                            mirrorFrom: "",
                            image: (post.metadata.attributes.first(where: { $0.traitType == "image"})?.value)!,
                            transactionHash: (post.metadata.attributes.first(where: { $0.traitType == "Transaction hash"})?.value)!,
                            scAddress: (post.metadata.attributes.first(where: { $0.traitType == "Contract address"})?.value)!,
                            fromAddress: (post.metadata.attributes.first(where: { $0.traitType == "From address"})?.value)!,
                            toAddress: (post.metadata.attributes.first(where: { $0.traitType == "To address"})?.value)!,
                            transferType: (post.metadata.attributes.first(where: { $0.traitType == "Transfer type"})?.value)!,
                            totalAmountOfComments: post.stats.totalAmountOfComments,
                            totalUpvotes: post.stats.totalUpvotes,
                            totalAmountOfMirrors: post.stats.totalAmountOfMirrors,
                            creationDate: createdAt
                        ))
                    } else if (data.publications.items[i].asMirror?.id != nil) {
                        let mirror = data.publications.items[i].asMirror!
                        let post = data.publications.items[i].asMirror!.mirrorOf.asPost!
                        
                        let createdAt = dateFormatter.date(from: mirror.createdAt)!
                        
                        posts.append(UserPostInfo(
                            id: mirror.id,
                            isMirror: true,
                            mirrorFrom: post.profile.ownedBy,
                            image: (post.metadata.attributes.first(where: { $0.traitType == "image"})?.value)!,
                            transactionHash: (post.metadata.attributes.first(where: { $0.traitType == "Transaction hash"})?.value)!,
                            scAddress: (post.metadata.attributes.first(where: { $0.traitType == "Contract address"})?.value)!,
                            fromAddress: (post.metadata.attributes.first(where: { $0.traitType == "From address"})?.value)!,
                            toAddress: (post.metadata.attributes.first(where: { $0.traitType == "To address"})?.value)!,
                            transferType: (post.metadata.attributes.first(where: { $0.traitType == "Transfer type"})?.value)!,
                            totalAmountOfComments: mirror.stats.totalAmountOfComments,
                            totalUpvotes: mirror.stats.totalUpvotes,
                            totalAmountOfMirrors: mirror.stats.totalAmountOfMirrors,
                            creationDate: createdAt
                        ))
                    }
                }
                
                continuation.resume(returning: UserPostsResponse(posts: posts, cursor: cursor))
            }
        }
    }
    
    static func getCommentsByPostId(postId: String) async -> [Comment] {
        await withCheckedContinuation { continuation in

            apolloClient.fetch(query: PostCommentsQuery(publicationId: postId)) { result in
                var comments: [Comment] = []
                
                guard let data = try? result.get().data else {
                    continuation.resume(returning: comments)
                    return
                }
                
                for i in 0..<data.publications.items.count {
                    let isoDate = data.publications.items[i].asComment!.createdAt
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let date = dateFormatter.date(from:isoDate)!
                    
                    comments.append(Comment(
                        id: data.publications.items[i].asComment!.id,
                        walletAddress: data.publications.items[i].asComment!.profile.ownedBy,
                        text: data.publications.items[i].asComment!.metadata.content!,
                        creationDate: date
                    ))
                }
                
                continuation.resume(returning: comments)
            }
        }
    }
    
    static func createPostTypedData(profileId: String, contentURI: String) async throws -> CreatePostTypedDataMutation.Data.CreatePostTypedData {
        guard let tokens = try? await LensProtocolService.refreshTokens() else {
            throw GraphQLErrors.unauthorized
        }
        
        let apolloWithAuth: ApolloClient = {
            let cache = InMemoryNormalizedCache()
            let store = ApolloStore(cache: cache)
            let authPayloads = ["x-access-token": tokens.accessToken]
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = authPayloads

            let client = URLSessionClient(sessionConfiguration: configuration, callbackQueue: nil)
            let provider = DefaultInterceptorProvider(client: client, shouldInvalidateClientOnDeinit: true, store: store)

            let url = URL(string: Constants.LENS_URL)!

            let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                                     endpointURL: url)

            return ApolloClient(networkTransport: requestChainTransport, store: store)
           }()
        
        return try await withCheckedThrowingContinuation { continuation in

            apolloWithAuth.perform(mutation: CreatePostTypedDataMutation(profileId: profileId, contentURI: contentURI)) { result in
                guard let data = try? result.get().data else {
                    continuation.resume(throwing: GraphQLErrors.profileNotCreated)
                    return
                }
                
                continuation.resume(returning: data.createPostTypedData)
            }
        }
    }
    
    // Profile
    
    static func createProfile(walletAddress: String) async throws -> Void {
        guard let tokens = try? await LensProtocolService.refreshTokens() else {
            throw GraphQLErrors.unauthorized
        }
        
        let profileName = "frenly_\(walletAddress.prefix(10))"
        
        let apolloWithAuth: ApolloClient = {
            let cache = InMemoryNormalizedCache()
            let store = ApolloStore(cache: cache)
            let authPayloads = ["x-access-token": tokens.accessToken]
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = authPayloads

            let client = URLSessionClient(sessionConfiguration: configuration, callbackQueue: nil)
            let provider = DefaultInterceptorProvider(client: client, shouldInvalidateClientOnDeinit: true, store: store)

            let url = URL(string: Constants.LENS_URL)!

            let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                                     endpointURL: url)

            return ApolloClient(networkTransport: requestChainTransport, store: store)
           }()
        
        return try await withCheckedThrowingContinuation { continuation in

            apolloWithAuth.perform(mutation: CreateProfileMutation(profileName: profileName)) { result in
                guard let data = try? result.get().data else {
                    continuation.resume(throwing: GraphQLErrors.profileNotCreated)
                    return
                }
                
                if (data.createProfile.asRelayError?.reason != nil) {
                    continuation.resume(throwing: GraphQLErrors.profileNotCreated)
                    return
                }

                continuation.resume()
            }
        }
    }
    
    // Response Types
    struct JWTPair {
        var accessToken: String
        var refreshToken: String
    }
    
    // // Posts
    
    struct FeedPostInfo {
        var id: String
        var ownerWalletAddress: String
        
        var isMirror: Bool
        var mirrorFrom: String
        
        var totalAmountOfComments: Int
        var totalUpvotes: Int
        var totalAmountOfMirrors: Int
    }
    
    struct UserPostsResponse {
        var posts: [UserPostInfo]
        var cursor: String?
    }
    
    struct UserPostInfo {
        var id: String
        
        var isMirror: Bool
        var mirrorFrom: String
        
        var image: String
    
        var transactionHash: String
        
        var scAddress: String
        var fromAddress: String
        var toAddress: String
        
        var transferType: String
        
        var totalAmountOfComments: Int
        var totalUpvotes: Int
        var totalAmountOfMirrors: Int
        
        var creationDate: Date
    }
    
    struct Comment {
        var id: String
        var walletAddress: String
        var text: String
        var creationDate: Date
    }
}
