//
//  DraftBackButton.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct DraftBackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.lightBlue)
                .opacity(0.2)
                .cornerRadius(20)
            
            VStack {
                Text("No more posts 👀")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                
                Text("Do some more activity on-chain and come back later for posting")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("BACK TO FEED")
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

struct DraftBackButton_Previews: PreviewProvider {
    static var previews: some View {
        DraftBackButton()
    }
}
