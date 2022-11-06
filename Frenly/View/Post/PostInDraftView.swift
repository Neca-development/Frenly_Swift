//
//  DraftLookup.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct PostInDraftView: View {
    @EnvironmentObject private var drafts: DraftFeedViewModel
    
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
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
            
            Text("FrenlyDraft")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.grayBlue)
            
            
            HStack {
                Link(destination: URL(string: "https://etherscan.io/tx/\(post.transactionHash)")!) {
                    Text("Etherscan")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            
            HStack {
                Button {} label: {
                    Text("PUBLISH")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .frame(
                            width: UIScreen.main.bounds.width * 0.44,
                            height: 30
                        )
                        .background(Color.lightBlue)
                        .foregroundColor(Color.white)
                        .cornerRadius(30)
                }
                
                Spacer()
                
                Button {} label: {
                    Text("DECLINE")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .frame(
                            width: UIScreen.main.bounds.width * 0.44,
                            height: 30
                        )
                        .background(Color.declineButtonBackground)
                        .foregroundColor(Color.declineButtonForeground)
                        .cornerRadius(30)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

struct PostInDraftView_Previews: PreviewProvider {
    static var previews: some View {
        PostInDraftView(post: Post())
            .environmentObject(DraftFeedViewModel())
    }
}
