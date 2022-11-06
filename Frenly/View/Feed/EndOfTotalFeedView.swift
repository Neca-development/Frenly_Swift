//
//  EndOfTotalFeedView.swift
//  Frenly
//
//  Created by Владислав on 03.11.2022.
//

import SwiftUI

struct EndOfTotalFeedView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.lightBlue)
                .opacity(0.2)
                .cornerRadius(20)
            
            VStack {
                Text("That’s all for now 👀")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                
                Text("Come back later for more or follow more frens to stay in touch on-chain")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                
                Button {
                } label: {
                    Text("INVITE FRENS")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(
                            width: UIScreen.main.bounds.width * 0.4,
                            height: 40
                        )
                        .background(Color.lightBlue)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                }
            }
        }
        .frame(
            width: UIScreen.main.bounds.width * 0.9,
            height: 180
        )
    }
}

struct EndOfTotalFeedView_Previews: PreviewProvider {
    static var previews: some View {
        EndOfTotalFeedView()
    }
}
