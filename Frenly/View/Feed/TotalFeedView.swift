//
//  FeedView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct TotalFeedView: View {
    @EnvironmentObject private var wallet: WalletViewModel
    @EnvironmentObject private var auth: AuthViewModel

    @Environment(\.refresh) private var refresh
    
    @StateObject private var feed = TotalFeedViewModel()
    @StateObject private var user = UserViewModel()
    
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack {                    
                    Divider()
                    
                    if (isRefreshing) {
                        ProgressView()
                            .frame(height: 50)
                    }
                    
                    ForEach(feed.posts.indices, id: \.self) { index in
                        NavigationLink {
                            PostWithCommentsView(post: Binding(
                                get: { feed.posts.indices.contains(index) ? feed.posts[index] : Post() },
                                set: { if (feed.posts.indices.contains(index)) { feed.posts[index] = $0 } }
                            ))
                            .environmentObject(wallet)
                        } label: {
                            PostWithUserView(
                                post: Binding(
                                    get: { feed.posts.indices.contains(index) ? feed.posts[index] : Post() },
                                    set: { if (feed.posts.indices.contains(index)) { feed.posts[index] = $0 } }
                                ),
                                navigateToUser: true
                            )
                            .environmentObject(wallet)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear() {
                            if (feed.posts.indices.contains(index) &&
                                feed.posts[index].id == feed.posts.last?.id
                            ) {
                                Task { await feed.fetchPosts() }
                            }
                        }
                        
                        Divider()
                    }
                    
                    if (feed.isFetching && feed.posts.count > 0) {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    
                    if (feed.isEndOfPage) {
                        EndOfTotalFeedView()
                    }
                }
                .background(GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .global).origin.y)
                })
                .onPreferenceChange(ViewOffsetKey.self) {
                    if $0 < -200 && !isRefreshing {
                        isRefreshing = true
                        Task {
                            await feed.refreshPosts()
                            isRefreshing = false
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    UserFeedNavTitle()
                        .onTapGesture {
                            if (!isRefreshing) {
                                isRefreshing = true
                                Task {
                                    await feed.refreshPosts()
                                    isRefreshing = false
                                }
                            }
                        }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        DraftFeedView()
                            .environmentObject(user)
                            .environmentObject(wallet)
                            .environmentObject(auth)
                    } label: {
                        avatar(name: user.user.avatar)
                    }
                }
            }
        }
        .onAppear() {
            Task {
                await feed.fetchPosts()
                await user.fetchUser()
            }
        }
    }
    
    func avatar(name: String) -> some View {
        AsyncImage(
            url: URL(string: "\(Constants.AVATAR_IMAGES_URL)/\(name)")!
        ) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } else if phase.error != nil {
                Image("Image_MockAvatar")
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .frame(
            width: 30,
            height: 30,
            alignment: .center
        )
    }
    
    private struct ViewOffsetKey: PreferenceKey {
        public typealias Value = CGFloat
        public static var defaultValue = CGFloat.zero

        public static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }
}

struct TotalFeedView_Previews: PreviewProvider {
    static var previews: some View {
        TotalFeedView()
            .environmentObject(WalletViewModel())
            .environmentObject(AuthViewModel())
    }
}
