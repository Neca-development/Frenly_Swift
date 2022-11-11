//
//  PostView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct PostWithCommentsView: View {
    @StateObject private var comments = CommentsViewModel()
    
    @State private var text = ""
    @State private var editorHeight: CGFloat = 20
    
    @State private var isContentShown = true
    
    @FocusState var commentsFocus: Int?
    
    var post: Post
    
    var body: some View {
        VStack {
            Divider()

            if (isContentShown) {
                FullViewPost(post: post)
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
                   
                    ForEach(comments.comments, id: \.id) { comment in
                        CommentView(comment: comment)
                    }
                    .onAppear {
                        reader.scrollTo(
                            comments.comments.last?.id,
                            anchor: .center
                        )
                    }
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
            
            // Keyboard placeholder
            
            Rectangle()
                .opacity(0.001)
                .frame(height: 10)
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
                        UserFeedView(walletAddress: post.ownerAddress)
                    } label: {
                        PostNavTitleView(post: post)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    CommentsNavTitle()
                }
            }
        }
        .onAppear() {
            Task { await comments.fetchComments(lensId: post.lensId) }
        }
    }
}

struct PostWithCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostWithCommentsView(post: Post())
        }
    }
}
