//
//  PostView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct PostWithCommentsView: View {
    @State private var text = ""
    @State private var editorHeight: CGFloat = 20
    
    @State private var isContentShown = true
    
    @FocusState var commentsFocus: Int?
    
    var body: some View {
        VStack {
            Divider()

            if (isContentShown) {
                FullViewPost()
                    .frame(
                        width: UIScreen.main.bounds.width * 0.9
                    )
            
                Text("Comments")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                    .padding(.top)
            }
            
            ScrollView(showsIndicators: false) {
                ScrollViewReader { reader in
                    CommentView()
                    
                    CommentView()
                    
                    CommentView()
                    
                    CommentView()
                    
                    CommentView()
                    
                    // TODO:
                    // Scroll to bottom via reader
                }
            }
            .frame(
                width: UIScreen.main.bounds.width * 0.9,
                alignment: .center
            )
            
            Divider()
                .animation(.easeInOut(duration: 0.4), value: editorHeight)
            
            HStack {
                CommentTextEditor(
                    text: $text,
                    textEditorHeight: $editorHeight,
                    focusedField: $commentsFocus,
                    onChangeAction: {
                        withAnimation(.easeInOut) { isContentShown = false }
                    },
                    onSubmitAction: {
                        withAnimation(.easeInOut) { isContentShown = true }
                    }
                )
                
                Button {
                    commentsFocus = nil
                    text = ""
                } label: {
                    Image("Image_Arrow")
                        .padding(.leading, 5)
                        .padding(.trailing)
                        .animation(.easeInOut(duration: 0.4), value: editorHeight)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            commentsFocus = nil
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackNavButton()
            }
            
            
            ToolbarItem(placement: .navigationBarLeading) {
                if (isContentShown) {
                    NavigationLink {
                        UserFeedView()
                    } label: {
                        PostNavTitleView()
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    CommentsNavTitle()
                }
            }
        }
    }
}

struct PostWithCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostWithCommentsView()
        }
    }
}
