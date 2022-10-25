//
//  CommentsNavTitle.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct CommentsNavTitle: View {
    var body: some View {
        HStack {
            Text("Comments")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            
            Spacer()
        }
    }
}

struct CommentsNavTitle_Previews: PreviewProvider {
    static var previews: some View {
        CommentsNavTitle()
    }
}
