//
//  PostView.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct PostWithCommentsView: View {
    @EnvironmentObject private var wallet: WalletViewModel
    
    @StateObject private var comments = CommentsViewModel()
    
    @State private var text = ""
    @State private var editorHeight: CGFloat = 20
    
    @State private var isContentShown = true
    @State private var isLoading = false
    
    @FocusState var commentsFocus: Int?
    
    @Binding var post: Post
    
    var body: some View {
        VStack {
            Divider()

            if (isContentShown) {
                FullViewPost(post: $post)
                    .frame(
                        width: UIScreen.main.bounds.width * 0.9
                    )
                    .environmentObject(wallet)
            
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
                    Task {
                        isLoading = true
                        
                        await sendComment()
                        
                        isLoading = false
                    }
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
                if (!isLoading) {
                    BackNavButton()
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                if (isContentShown) {
                    NavigationLink {
                        UserFeedView(walletAddress: post.ownerAddress)
                            .environmentObject(wallet)
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
            Task {
                await comments.fetchComments(lensId: post.lensId)
            }
        }
        .overlay {
            if (isLoading) {
                AppLoader()
            }
        }
    }
    
    func sendComment() async -> Void {
        if (wallet.chainId != Constants.MUMBAI_CHAIN_ID_DECIMAL) {
            await wallet.switchNetworkToMumbai()
        }
        
        guard let walletAddress = wallet.walletAddress else {
            return
        }
        
        // Retrieve profile ID
        guard let isOwnLensProfile = try? await AuthWebService.isOwnLensProfile(walletAddress: walletAddress) else {
            return
        }
        
        if (!isOwnLensProfile.data) {
            guard let _ = try? await LensProtocolService.createProfile(walletAddress: walletAddress) else {
                return
            }
        }
        
        let lensProfileId = (await SmartContractService().lensIdByWalletAddress(walletAddress: walletAddress))!
        
        // Form metadata
        
        guard let metadataURL = try? await FeedWebService.getCommentsMetadataURL(
            lensId: post.lensId,
            comment: text
        ) else {
            return
        }
        
        guard let createCommentData = try? await LensProtocolService.createCommentTypedData(
            profileId: lensProfileId,
            publicationId: post.lensId,
            contentURI: metadataURL.data
        ) else {
            return
        }
        
        let typedData = createCommentData.typedData
        
        // Encode metadata to ABI
        
        guard let data = await SmartContractService().createCommentABIData(params: typedData) else {
            return
        }
        
        guard let _ = try? await wallet.sendTransaction(data: data) else {
            return
        }
        
        let postOwner = try? await UserWebService.getUserInfo(walletAddress: wallet.walletAddress!)
        
        comments.comments.append(Comment(
            id: UUID().uuidString,
            avatar: postOwner?.data.avatar ?? "",
            username: postOwner?.data.username ?? UtilsService.User.nameFromWalletAddress(walletAddress: wallet.walletAddress!),
            text: text,
            createdAt: Date()
        ))
        
        text = ""
        post.totalComments += 1
    }
}

struct PostWithCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostWithCommentsView(post: .constant(Post()))
                .environmentObject(WalletViewModel())
        }
    }
}
