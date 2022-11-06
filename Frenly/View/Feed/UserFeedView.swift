//
//  UserFeedView.swift
//  Frenly
//
//  Created by Владислав on 25.10.2022.
//

import SwiftUI

struct UserFeedView: View {
    @StateObject private var user = UserViewModel()
    
    var body: some View {
        ScrollView {
            UserInfoView(avatar: "", description: "description")

            NavigationLink {
                PostWithCommentsView()
            } label: {
                PostWithUserView()
            }
            .buttonStyle(PlainButtonStyle())

            Divider()
            
            NavigationLink {
                PostWithCommentsView()
            } label: {
                PostWithUserView()
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
            
            NavigationLink {
                PostWithCommentsView()
            } label: {
                PostWithUserView()
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
            
            NavigationLink {
                PostWithCommentsView()
            } label: {
                PostWithUserView()
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackNavButton()
            }
            
            ToolbarItem(placement: .principal) {
                Text("Username")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            }
        }
        .onAppear() {
            Task { await user.fetchUser() }
        }
    }
}

struct UserFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserFeedView()
        }
    }
}
