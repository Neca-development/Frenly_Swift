//
//  PostWithoutUser.swift
//  Frenly
//
//  Created by Владислав on 10.11.2022.
//

import SwiftUI

struct PostWithoutUser: View {
    var post = Post()
    
    var body: some View {
        VStack(alignment: .leading) {
            if (post.isMirror) {
                HStack(spacing: 0) {
                    Text("🪞mirrored from ")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Text(post.mirroredFrom)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                }
            }
            
            Text(post.getFormattedDate())
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.grayBlue)
            
            if (post.fromAddress == Constants.ETH_NULL_ADDRESS) {
                Text("🎉 Minted a new NFT from ")
                    .font(.system(
                        size: 18,
                        weight: .regular,
                        design: .rounded
                    ))
                Text(post.contractAddress)
                    .font(.system(
                        size: 18,
                        weight: .regular,
                        design: .rounded
                    ))
                    .foregroundColor(.blue)
            }
            
            if (post.fromAddress != Constants.ETH_NULL_ADDRESS) {
                Text("📤 \(post.transferType == "SEND" ? "Sent" : "Recieved") NFT \(post.transferType == "SEND" ? "to" : "from")")
                    .font(.system(
                        size: 18,
                        weight: .regular,
                        design: .rounded
                    ))
                
                Text(post.transferType == "SEND" ? post.fromAddress : post.toAddress)
                    .font(.system(
                        size: 18,
                        weight: .regular,
                        design: .rounded
                    ))
                    .foregroundColor(.blue)
            }
            
            AsyncImage(
                url: URL(string: "\(Constants.TOKEN_IMAGES_URL)/\(post.image)")!
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error == nil {
                    ProgressView()
                }
            }
            .frame(
                width: UIScreen.main.bounds.width * 0.9,
                height: UIScreen.main.bounds.height * 0.3,
                alignment: .center
            )
            .cornerRadius(30)
            
            Text("FrenlyPost")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.grayBlue)
            
            
            HStack {
                Link(destination: URL(string: "https://etherscan.io/tx/\(post.transactionHash)")!) {
                    Text("Etherscan")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Image("Image_Hearth")
                Text("\(post.totalLikes)")
                    .foregroundColor(.grayBlue)
                    .padding(.trailing, 10)
                
                Image("Image_Comment")
                Text("\(post.totalComments)")
                    .foregroundColor(.grayBlue)
                    .padding(.trailing, 10)

                Image("Image_Repost")
                Text("\(post.totalMirrors)")
                    .foregroundColor(.grayBlue)
                    .padding(.trailing, 10)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width * 0.9,
            alignment: .leading
        )
    }
}

struct PostWithoutUser_Previews: PreviewProvider {
    static var previews: some View {
        PostWithoutUser()
    }
}
