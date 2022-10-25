//
//  PostLookup.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct FullViewPost: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text("Transfer type to ")
                Text("wallet_user")
            }
            .font(.system(
                size: 20,
                weight: .bold,
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
    }
}

struct PostLookup_Previews: PreviewProvider {
    static var previews: some View {
        FullViewPost()
    }
}
