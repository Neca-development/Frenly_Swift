//
//  DraftUserInfo.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct UserInfo: View {
    var body: some View {
        VStack {
            Image("Image_MockAvatar")
                .resizable()
                .frame(width: 80, height: 80)
                .padding(.top)
            
            Text("Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.bottom)
            
            Divider()
        }
    }
}

struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        UserInfo()
    }
}
