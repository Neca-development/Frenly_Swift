//
//  PostWithUserLookup.swift
//  Frenly
//
//  Created by Владислав on 25.10.2022.
//

import SwiftUI

struct PostWithUserView: View {
    @EnvironmentObject private var wallet: WalletViewModel
    
    var post = Post()
    var navigateToUser = false
    
    var body: some View {
        HStack(alignment: .top) {
            if (navigateToUser) {
                NavigationLink {
                    UserFeedView(walletAddress: post.ownerAddress)
                        .environmentObject(wallet)
                } label: {
                    avatar(name: post.avatar)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                avatar(name: post.avatar)
            }
            
            VStack(alignment: .leading) {
                Text(post.username)
                    .font(.system(size: 20, weight: .bold, design: .rounded))

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
                
                if (post.isMirror) {
                    Text(post.mirrorDescription)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.grayBlue)
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
                    width: UIScreen.main.bounds.width * 0.75,
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
                width: UIScreen.main.bounds.width - 80,
                alignment: .leading
            )
        }
    }
    
    func avatar(name: String) -> some View {
        AsyncImage(
            url: URL(string: "\(Constants.AVATAR_IMAGES_URL)/\(name)")!
        ) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } else {
                Image("Image_MockAvatar")
                    .resizable()
            }
        }
        .frame(
            width: 40,
            height: 40,
            alignment: .center
        )
    }
}

struct PostWithUserView_Previews: PreviewProvider {
    static var previews: some View {
        PostWithUserView()
            .environmentObject(WalletViewModel())
    }
}
