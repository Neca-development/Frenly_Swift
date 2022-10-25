//
//  DraftView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct DraftFeedView: View {
    var body: some View {
        ScrollView {
            UserInfo()
            
            PostInDraftView()
            Divider()
            PostInDraftView()
            Divider()
            PostInDraftView()
            Divider()
            PostInDraftView()
            Divider()
            
            DraftBackButton()
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
    }
}

struct DraftFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DraftFeedView()
        }
    }
}
