//
//  CommentView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct CommentView: View {
    var comment: Comment
    
    var body: some View {
        HStack(alignment: .top) {
            avatar(name: comment.avatar)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.username)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    Spacer()
                    
                    Text(comment.getFormattedDate())
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.grayBlue)
                        .padding(.trailing)
                }
                .padding(.bottom, 2)
                
                Text(comment.text)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                
                Divider()
            }
            .padding(.leading)
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
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
            width: 25,
            height: 25,
            alignment: .center
        )
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: Comment())
    }
}
