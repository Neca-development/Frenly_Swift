//
//  DraftUserInfo.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct UserInfoView: View {
    var avatar: String
    var description: String
    var walletAddress: String
    
    @State private var ensName: String?
    
    var body: some View {
        VStack {
            AsyncImage(
                url: URL(string: "\(Constants.AVATAR_IMAGES_URL)/\(avatar)")!
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } else if phase.error != nil {
                    Image("Image_MockAvatar")
                        .resizable()
                } else {
                    ProgressView()
                }
            }
            .frame(
                width: 80,
                height: 80,
                alignment: .center
            )
            
            if (walletAddress.count >= 42 && ensName == nil) {
                Link(destination: URL(string: "https://etherscan.io/address/\(walletAddress)")!) {
                    Text("\(walletAddress.substr(0, 5)!)...\(walletAddress.substr(38, 4)!)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .padding()
                        .foregroundColor(.blue)
                }
            }
            
            if (ensName != nil) {
                Link(destination: URL(string: "https://etherscan.io/address/\(walletAddress)")!) {
                    Text(ensName!)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .padding()
                        .foregroundColor(.blue)
                }
            }
            
            if (description.count > 0) {
                Text(description)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .padding(.bottom)
            }
        }
        .onAppear() {
            Task {
                let response = try? await ENSWebService.getUserNameByAddress(walletAddress: walletAddress)
                
                ensName = response?.data
            }
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(
            avatar: "",
            description: "Description",
            walletAddress: "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"
        )
    }
}
