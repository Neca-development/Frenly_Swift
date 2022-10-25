//
//  BackButton.swift
//  Frenly
//
//  Created by Владислав on 25.10.2022.
//

import SwiftUI

struct BackNavButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .resizable()
                .foregroundColor(.accentColor)
                .frame(
                    width: 10,
                    height: 20
                )
        }
    }
}

struct BackNavButton_Previews: PreviewProvider {
    static var previews: some View {
        BackNavButton()
    }
}
