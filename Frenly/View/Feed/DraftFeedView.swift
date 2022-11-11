//
//  DraftView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct DraftFeedView: View {
    @EnvironmentObject private var user: UserViewModel
    
    @EnvironmentObject private var wallet: WalletViewModel
    @EnvironmentObject private var auth: AuthViewModel
    
    @Environment(\.refresh) private var refresh
    
    @StateObject private var drafts = DraftFeedViewModel()
    
    @State private var isEditing = false
    @State private var isRefreshing = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if (!isEditing) {
                UserInfoView(
                    avatar: user.user.avatar,
                    description: user.user.description
                )
                
                Divider()
                
                LazyVStack {
                    if (isRefreshing) {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    
                    ForEach(drafts.posts, id: \.id) { post in
                        PostInDraftView(post: post)
                            .environmentObject(drafts)
                    }
                }
                .background(GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .global).origin.y)
                })
                .onPreferenceChange(ViewOffsetKey.self) {
                    if $0 < -80 && !isRefreshing {
                        isRefreshing = true
                        Task {
                            await refresh?()
                            isRefreshing = false
                        }
                    }
                }
                
            
                DraftBackButton()
            } else {
                UserEditView()
                    .environmentObject(user)
                    .environmentObject(wallet)
                    .environmentObject(auth)
            }
        }
        .refreshable {
            drafts.posts = []
            await drafts.fetchPosts()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackNavButton()
            }
            
            ToolbarItem(placement: .principal) {
                if (!isEditing) {
                    Text(user.user.username)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton
            }
        }
        .onAppear() {
            Task {
                await user.fetchUser()
                await drafts.fetchPosts()
            }
        }
    }
    
    var EditButton: some View {
        Button {
            withAnimation(.easeInOut) {
                isEditing.toggle()
            }
            
            if (!isEditing) {
                Task { await user.updateUserInfo() }
            }
        } label: {
            ZStack {
                if (isEditing) {
                    Text("Done")
                } else {
                    Text("Edit")
                }
            }
            .font(.system(size: 22, weight: .regular, design: .rounded))
        }
    }
    
    private struct ViewOffsetKey: PreferenceKey {
        public typealias Value = CGFloat
        public static var defaultValue = CGFloat.zero

        public static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }
}

struct DraftFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DraftFeedView()
                .environmentObject(UserViewModel())
        }
    }
}
