//
//  UserHeadlineView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct UserFeedNavTitle: View {
    var body: some View {
        HStack {
            Image("Image_Eyes_Simple")
                .resizable()
                .frame(width: 40, height: 30)
            
            Text("frenly feed")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .padding(.leading)
        }
    }
}

struct UserFeedNavTitle_Previews: PreviewProvider {
    static var previews: some View {
        UserFeedNavTitle()
    }
}
