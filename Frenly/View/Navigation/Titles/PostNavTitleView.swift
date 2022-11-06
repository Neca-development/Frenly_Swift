//
//  PostNavTitleView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct PostNavTitleView: View {
    var post: Post
    
    var body: some View {
        HStack {
            avatar(name: post.avatar)
            
            VStack(alignment: .leading) {
                Text(post.username)
                    .font(.system(size: 20, weight: .bold, design: .rounded))

                Text(post.getFormattedDate())
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.grayBlue)
            }
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
            } else if phase.error != nil {
                Image("Image_MockAvatar")
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .frame(
            width: 35,
            height: 35,
            alignment: .center
        )
    }
}

struct PostNavTitleView_Previews: PreviewProvider {
    static var previews: some View {
        PostNavTitleView(post: Post())
    }
}
