//
//  AppLoader.swift
//  Frenly
//
//  Created by Владислав on 13.11.2022.
//

import SwiftUI

struct AppLoader: View {    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
                .opacity(0.85)
                .blur(radius: 20)
            
            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(Color.appLoader)
                .opacity(0.9)
                .frame(width: 300, height: 50)
            
            HStack {
                ProgressView()
                    .padding(.leading)
                    .padding(.trailing, 5)
                
                Text("Loading... Please, wait")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                
                Spacer()
            }
            .frame(width: 300, height: 50)
        }
    }
}

struct AppLoader_Previews: PreviewProvider {
    static var previews: some View {
        AppLoader()
            .preferredColorScheme(.dark)
    }
}
