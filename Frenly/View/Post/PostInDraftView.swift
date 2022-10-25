//
//  DraftLookup.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct PostInDraftView: View {
    var body: some View {
        VStack(alignment: .leading) {
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
        PostInDraftView()
    }
}
