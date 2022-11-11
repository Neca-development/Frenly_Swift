//
//  UserFeedView.swift
//  Frenly
//
//  Created by Владислав on 25.10.2022.
//

import SwiftUI

struct UserFeedView: View {
    @StateObject private var user = UserViewModel()
    @StateObject private var feed = UserFeedViewModel()
    
    var walletAddress: String
    
    var body: some View {
        ScrollView {
            UserInfoView(avatar: user.user.avatar, description: user.user.description)
            
            Button {
                
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
            
            Divider()
            
            LazyVStack {
                ForEach(feed.posts, id: \.lensId) { post in
                    NavigationLink {
                        PostWithCommentsView(post: post)
                    } label: {
                        PostWithoutUser(post: post)
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
            }
        }
    }
}

struct UserFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserFeedView(walletAddress: "")
        }
    }
}
