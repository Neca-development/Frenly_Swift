//
//  CommentView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct CommentView: View {
    var body: some View {
        HStack(alignment: .top) {
            Image("Image_MockAvatar")
                .resizable()
                .frame(
                    width: 25,
                    height: 25
                )
            
            VStack(alignment: .leading) {
                HStack {
                    Text("username")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    Spacer()
                    
                    Text("1H")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.grayBlue)
                        .padding(.trailing)
                }
                .padding(.bottom, 2)
                
                Text("My funny comment")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                
                Divider()
            }
            .padding(.leading)
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
    }
}
