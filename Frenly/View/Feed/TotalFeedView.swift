//
//  FeedView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct TotalFeedView: View {
    @EnvironmentObject private var wallet: WalletViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                Divider()
                
                NavigationLink {
                    PostWithCommentsView()
                } label: {
                    PostWithUserView(navigateToUser: true)
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                
                NavigationLink {
                    PostWithCommentsView()
                } label: {
                    PostWithUserView(navigateToUser: true)
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                
                NavigationLink {
                    PostWithCommentsView()
                } label: {
                    PostWithUserView(navigateToUser: true)
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                
                NavigationLink {
                    PostWithCommentsView()
                } label: {
                    PostWithUserView(navigateToUser: true)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    UserFeedNavTitle()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        DraftFeedView()
                    } label: {
                        Image("Image_MockAvatar")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
    }
}

struct TotalFeedView_Previews: PreviewProvider {
    static var previews: some View {
        TotalFeedView()
            .environmentObject(WalletViewModel())
    }
}
