//
//  PostWithUserLookup.swift
//  Frenly
//
//  Created by Владислав on 25.10.2022.
//

import SwiftUI

struct PostWithUserView: View {
    var navigateToUser = false
    var isMirror: Bool = Bool.random()
    
    var body: some View {
        HStack(alignment: .top) {
            if (navigateToUser) {
                NavigationLink {
                    UserFeedView()
                } label: {
                    Image("Image_MockAvatar")
                        .resizable()
                        .frame(
                            width: 40,
                            height: 40
                        )
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Image("Image_MockAvatar")
                    .resizable()
                    .frame(
                        width: 40,
                        height: 40
                    )
            }
            
            VStack(alignment: .leading) {
                if (isMirror) {
                    HStack(spacing: 0) {
                        Text("🪞mirrored from ")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                        Text("from address")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                } else {
                    Text("username")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                
                Text("SEP, 11 AT 9:41 AM")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.grayBlue)
                    
                HStack(spacing: 0) {
                    Text("Transfer type to ")
                    Text("wallet_user")
                }
                .font(.system(
                    size: 18,
                    weight: .regular,
                    design: .rounded
                ))
                
                Rectangle()
                    .frame(
                        height: UIScreen.main.bounds.height * 0.4
                    )
                    .cornerRadius(30)
                
                Text("NFT name #id")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundColor(.grayBlue)
                
                
                HStack {
                    Text("Polygonscan")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Image("Image_Hearth")
                    Text("0")
                        .foregroundColor(.grayBlue)
                        .padding(.trailing, 10)
                    
                    Image("Image_Comment")
                    Text("0")
                        .foregroundColor(.grayBlue)
                        .padding(.trailing, 10)

                    Image("Image_Repost")
                    Text("0")
                        .foregroundColor(.grayBlue)
                        .padding(.trailing, 10)
                }
            }
            .frame(
                width: UIScreen.main.bounds.width - 80,
                alignment: .leading
            )
        }
    }
}

struct PostWithUserView_Previews: PreviewProvider {
    static var previews: some View {
        PostWithUserView()
    }
}
