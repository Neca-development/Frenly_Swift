//
//  PostWithoutUser.swift
//  Frenly
//
//  Created by Владислав on 10.11.2022.
//

import SwiftUI

struct PostWithoutUser: View {
    @EnvironmentObject private var wallet: WalletViewModel
    
    @State private var isLikeInProgress = false
    @State private var isMirrorInProgress = false
    
    @State private var isLiked = false
    
    @State private var isDescriptionPopover = false
    @State private var description = ""
    
    @Binding var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            if (post.isMirror) {
                HStack(spacing: 0) {
                    Text("🪞mirrored from ")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Text(post.mirroredFrom)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                }
            }
            
            Text(post.getFormattedDate())
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.grayBlue)
            
            if (post.fromAddress == Constants.ETH_NULL_ADDRESS) {
                Text("🎉 Minted a new NFT from ")
                    .font(.system(
                        size: 18,
                        weight: .regular,
                        design: .rounded
                    ))
                Text(post.contractAddress)
                    .font(.system(
                        size: 18,
                        weight: .regular,
                        design: .rounded
                    ))
                    .foregroundColor(.blue)
            }
            
            if (post.fromAddress != Constants.ETH_NULL_ADDRESS) {
                Text("📤 \(post.transferType == "SEND" ? "Sent" : "Recieved") NFT \(post.transferType == "SEND" ? "to" : "from")")
                    .font(.system(
                        size: 18,
                        weight: .regular,
                        design: .rounded
                    ))
                
                Text(post.transferType == "SEND" ? post.fromAddress : post.toAddress)
                    .font(.system(
                        size: 18,
                        weight: .regular,
                        design: .rounded
                    ))
                    .foregroundColor(.blue)
            }
            
            AsyncImage(
                url: URL(string: "\(Constants.TOKEN_IMAGES_URL)/\(post.image)")!
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error == nil {
                    ProgressView()
                }
            }
            .frame(
                width: UIScreen.main.bounds.width * 0.9,
                height: UIScreen.main.bounds.height * 0.3,
                alignment: .center
            )
            .cornerRadius(30)
            
            Text("FrenlyPost")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.grayBlue)
            
            
            HStack {
                Link(destination: URL(string: "https://etherscan.io/tx/\(post.transactionHash)")!) {
                    Text("Etherscan")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button {
                    Task {
                        if (isLikeInProgress || isMirrorInProgress) {
                            return
                        }
                        
                        isLikeInProgress = true
                        await addReaction()
                        isLikeInProgress = false
                    }
                } label: {
                    if (isLiked) {
                        Image("Image_Hearth")
                    } else {
                        Image("Image_Hearth_Border")
                    }
                    
                    Text("\(post.totalLikes)")
                        .foregroundColor(.grayBlue)
                        .padding(.trailing, 10)
                }
                
                Image("Image_Comment")
                Text("\(post.totalComments)")
                    .foregroundColor(.grayBlue)
                    .padding(.trailing, 10)

                Button {
                    if (isLikeInProgress || isMirrorInProgress) {
                        return
                    }
                    
                    isDescriptionPopover = true
                    isMirrorInProgress = true
                } label: {
                    Image("Image_Repost")
                    Text("\(post.totalMirrors)")
                        .foregroundColor(.grayBlue)
                        .padding(.trailing, 10)
                }
                .popover(isPresented: $isDescriptionPopover) {
                    Text("Enter mirror description")
                        .font(.headline)
                    
                    TextField("Description...", text: $description)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                        .frame(
                            width: UIScreen.main.bounds.width * 0.7,
                            height: 40
                        )
                        .background(Color.commentInputBackground)
                        .cornerRadius(20)
                        .padding()
                    
                    HStack {
                        Button {
                            isDescriptionPopover = false

                            Task {
                                await mirror(text: description)
                                isMirrorInProgress = false
                            }
                        } label: {
                            Text("Mirror")
                                .foregroundColor(.blue)
                        }
                        
                        Button {
                            isMirrorInProgress = false
                            isDescriptionPopover = false
                        } label: {
                            Text("Dismiss")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Button {
                    UtilsService.TwitterUtil.redirectToTwitter(post: post)
                } label: {
                    Image("Image_Twitter")
                        .resizable()
                        .frame(width: 23, height: 20)
                        .padding(.trailing, 10)
                }
            }
        }
        .frame(
            width: UIScreen.main.bounds.width * 0.9,
            alignment: .leading
        )
        .onAppear() {
            Task {
                guard let walletAddress = wallet.walletAddress else {
                    return
                }
                
                guard let lensProfileId = await SmartContractService().lensIdByWalletAddress(walletAddress: walletAddress) else {
                    return
                }
                
                isLiked = await LensProtocolService.isReactedByUser(profileId: lensProfileId, publicationId: post.lensId)
            }
        }
    }
    
    func mirror(text: String) async -> Void {
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
        
        var postId = post.lensId
        
        if (post.isMirror) {
            guard let originalId = await LensProtocolService.getPublicationIdByMirrorId(publicationId: post.lensId) else {
                return
            }
            
            postId = originalId
        }
        
        guard let createMirrorData = try? await LensProtocolService.createMirrorTypedData(
            profileId: lensProfileId,
            publicationId: postId
        ) else {
            return
        }
        
        let typedData = createMirrorData.typedData
        
        // Encode metadata to ABI
        
        guard let data = await SmartContractService().createMirrorABIData(params: typedData) else {
            return
        }
        
        guard let txHash = try? await wallet.sendTransaction(data: data) else {
            return
        }
        
        var response = await SmartContractService().getTransactionReceipt(txHash: txHash)
        
        let maxSleeps = 60
        var sleepCounter = 0
        
        // Wait until it got mined
        
        while (response == nil && sleepCounter < maxSleeps) {
            try! await Task.sleep(nanoseconds: 1_000_000_000)
            
            response = await SmartContractService().getTransactionReceipt(txHash: txHash)
            
            sleepCounter += 1
        }
        
        if (sleepCounter == maxSleeps) {
            return
        }
        
        if (response!!.status!.quantity.isZero) {
            return
        }
        
        // retrieve external lens ID
        
        guard let postCreatedLog = response!!.logs.first(where: { $0.topics[0].hex() == Constants.TOPIC_MIRROR_CREATED }) else {
            return
        }
        let publicationIdHex = postCreatedLog.topics[2].hex()
        var publicationId = String(Int(hexString: publicationIdHex)!, radix: 16)
        
        if (publicationId.count % 2 == 1) {
            publicationId = "0" + publicationId
        }
        
        publicationId = "0x" + publicationId
        
        let externalPubId = "\(lensProfileId)-\(publicationId)"
        
        guard let statusCode = try? await FeedWebService.repostContent(
            oldPostLensId: post.lensId,
            newLensId: externalPubId,
            description: text
        ) else {
            return
        }
        
        if (statusCode != 201) {
            return
        }
        
        post.totalMirrors += 1
    }
    
    func addReaction() async -> Void {
        if (!isLiked) {
            post.totalLikes += 1
            isLiked = true
        } else {
            post.totalLikes -= 1
            isLiked = false
        }
        
        // Retrieve profile ID
        guard let walletAddress = wallet.walletAddress else {
            return
        }
        
        guard let isOwnLensProfile = try? await AuthWebService.isOwnLensProfile(walletAddress: walletAddress) else {
            return
        }
        
        if (!isOwnLensProfile.data) {
            guard let _ = try? await LensProtocolService.createProfile(walletAddress: walletAddress) else {
                return
            }
        }
        
        guard let lensProfileId = await SmartContractService().lensIdByWalletAddress(walletAddress: walletAddress) else {
            return
        }
        
        if (!isLiked) {
            guard let _ = try? await LensProtocolService.upvote(
                profileId: lensProfileId,
                publicationId: post.lensId
            ) else {
                return
            }
        } else {
            guard let _ = try? await LensProtocolService.removeUpvote(
                profileId: lensProfileId,
                publicationId: post.lensId
            ) else {
                return
            }
        }
    }
}

struct PostWithoutUser_Previews: PreviewProvider {
    static var previews: some View {
        PostWithoutUser(post: .constant(Post()))
    }
}
