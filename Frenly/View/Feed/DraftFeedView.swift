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
    
    @StateObject private var drafts = DraftFeedViewModel()
    
    @State private var isEditing = false
    
    var body: some View {
        ScrollView {
            if (!isEditing) {
                UserInfoView(
                    avatar: user.user.avatar,
                    description: user.user.description
                )
                
                PostInDraftView()
                Divider()
                PostInDraftView()
                Divider()
                PostInDraftView()
                Divider()
                PostInDraftView()
                Divider()
            
                DraftBackButton()
            } else {
                UserEditView()
                    .environmentObject(user)
                    .environmentObject(wallet)
                    .environmentObject(auth)
            }
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
}

struct DraftFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DraftFeedView()
                .environmentObject(UserViewModel())
        }
    }
}
