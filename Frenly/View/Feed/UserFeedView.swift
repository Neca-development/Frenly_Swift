//
//  UserFeedView.swift
//  Frenly
//
//  Created by Владислав on 25.10.2022.
//

import SwiftUI

import JWTDecode

struct UserFeedView: View {
    @EnvironmentObject private var wallet: WalletViewModel
    
    @StateObject private var user = UserViewModel()
    @StateObject private var feed = UserFeedViewModel()
    
    @State private var isFollowing = false
    
    var walletAddress: String
    var showFollowButton: Bool {
        guard let token = AuthTokenHelper.readAccessToken() else {
            return false
        }
        
        guard let jwt = try? decode(jwt: token) else {
            return false
        }
        
        guard let currentUserAddress = jwt.body["walletAddress"] as? String else {
            return false
        }
        
        if (currentUserAddress.lowercased() == walletAddress.lowercased()) {
            return false
        }
        
        return true
    }
    
    var body: some View {
        ScrollView {
            UserInfoView(
                avatar: user.user.avatar,
                description: user.user.description,
                walletAddress: walletAddress
            )

            if (showFollowButton) {
                Text("Followers: \(user.user.totalFollows)")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .padding(.top)
                
                if (!isFollowing) {
                    Button {
                        Task {
                            guard let status = try? await UserWebService.subscribe(walletAddress: walletAddress) else {
                                return
                            }
                            
                            if (status == 201) {
                                isFollowing = true
                                user.user.totalFollows += 1
                            }
                        }
                    } label: {
                        Text("Follow")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .frame(
                                width: UIScreen.main.bounds.width * 0.3,
                                height: 40
                            )
                            .background(Color.lightBlue)
                            .foregroundColor(Color.white)
                            .cornerRadius(20)
                            .padding(.bottom, 20)
                    }
                } else {
                    Button {
                        Task {
                            guard let status = try? await UserWebService.unsubscribe(walletAddress: walletAddress) else {
                                return
                            }
                            
                            if (status == 200) {
                                isFollowing = false
                                user.user.totalFollows -= 1
                            }
                        }
                    } label: {
                        Text("Unfollow")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .frame(
                                width: UIScreen.main.bounds.width * 0.3,
                                height: 40
                            )
                            .background(Color.grayBlue)
                            .foregroundColor(Color.white)
                            .cornerRadius(20)
                            .padding(.bottom, 20)
                    }
                }
            }
            
            Divider()
            
            LazyVStack {
                ForEach($feed.posts, id: \.lensId) { $post in
                    NavigationLink {
                        PostWithCommentsView(post: $post)
                            .environmentObject(wallet)
                    } label: {
                        PostWithoutUser(post: $post)
                            .environmentObject(wallet)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear() {
                        if (post.lensId == feed.posts.last?.lensId) {
                            Task { await feed.fetchPosts(walletAddress: walletAddress) }
                        }
                    }
                    
                    Divider()
                }
                
                if (feed.isFetching) {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                
                if (feed.isEndOfPage) {
                    EndOfTotalFeedView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackNavButton()
            }
            
            ToolbarItem(placement: .principal) {
                Text(user.user.username)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            }
        }
        .onAppear() {
            Task {
                await user.fetchUserByWalletAddress(walletAddress: walletAddress)
                await feed.fetchPosts(walletAddress: walletAddress)
                
                if (showFollowButton) {
                    guard let isFollowig = try? await UserWebService.isFollow(walletAddress: walletAddress) else {
                        return
                    }
                    
                    self.isFollowing = isFollowig.data
                }
            }
        }
    }
}

struct UserFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserFeedView(walletAddress: "")
                .environmentObject(WalletViewModel())
        }
    }
}
