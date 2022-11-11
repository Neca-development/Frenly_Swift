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
            
            if (description.count > 0) {
                Text(description)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .padding(.bottom)
            }
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(
            avatar: "",
            description: "Description"
        )
    }
}
