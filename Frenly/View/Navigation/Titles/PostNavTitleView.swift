//
//  PostNavTitleView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct PostNavTitleView: View {
    var body: some View {
        HStack {
            Image("Image_MockAvatar")
                .resizable()
                .frame(width: 35, height: 35)
            
            VStack(alignment: .leading) {
                Text("username")
                    .font(.system(size: 20, weight: .bold, design: .rounded))

                Text("SEP 11 AT 9:41 AM")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.grayBlue)
            }
        }
    }
}

struct PostNavTitleView_Previews: PreviewProvider {
    static var previews: some View {
        PostNavTitleView()
    }
}
