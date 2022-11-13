//
//  DraftLookup.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

import Web3
import Web3ContractABI
import PromiseKit
import CryptoSwift

struct PostInDraftView: View {
    @EnvironmentObject private var drafts: DraftFeedViewModel
    @EnvironmentObject private var wallet: WalletViewModel
    
    var post: Post
    
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
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
            
            Text("FrenlyDraft")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.grayBlue)
            
            
            HStack {
                Link(destination: URL(string: "https://etherscan.io/tx/\(post.transactionHash)")!) {
                    Text("Etherscan")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            
            HStack {
                Button {
                    Task {
                        isLoading = true
                        
                        await publishPostAction()
                        
                        isLoading = false
                    }
                } label: {
                    Text("PUBLISH")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .frame(
                            width: UIScreen.main.bounds.width * 0.44,
                            height: 30
                        )
                        .background(Color.lightBlue)
                        .foregroundColor(Color.white)
                        .cornerRadius(30)
                }
                
                Spacer()
                
                Button {
                    Task {
                        isLoading = true
                        
                        await declinePostAction()
                        
                        isLoading = false
                    }
                } label: {
                    Text("DECLINE")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .frame(
                            width: UIScreen.main.bounds.width * 0.44,
                            height: 30
                        )
                        .background(Color.declineButtonBackground)
                        .foregroundColor(Color.declineButtonForeground)
                        .cornerRadius(30)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
    
    func publishPostAction() async -> Void {
//        await wallet.switchNetworkToMumbai()
        
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
        
        guard let metadataURL = try? await FeedWebService.getOwnedPostMetadataURL(contentId: post.id) else {
            return
        }
        
        guard let createPostTypedData = try? await LensProtocolService.createPostTypedData(
            profileId: lensProfileId,
            contentURI: metadataURL.data
        ) else {
            return
        }
        
        let typedData = createPostTypedData.typedData
        
        // Encode metadata to ABI
        
        guard let data = await SmartContractService().createPostABIData(params: typedData) else {
            return
        }
        
        // Send transaction
        
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
        
        guard let postCreatedLog = response!!.logs.first(where: { $0.topics[0].hex() == Constants.TOPIC_POST_CREATED }) else {
            return
        }
        let publicationIdHex = postCreatedLog.topics[2].hex()
        var publicationId = String(Int(hexString: publicationIdHex)!, radix: 16)
        
        if (publicationId.count % 2 == 1) {
            publicationId = "0" + publicationId
        }
        
        publicationId = "0x" + publicationId
        
        let externalPubId = "\(lensProfileId)-\(publicationId)"
        
        // Publish on backend
        
        print(externalPubId)
        
        guard let bindStatusCode = try? await FeedWebService.bindContentWithLensId(contentId: post.id, lensId: externalPubId) else {
            return
        }
                
        if (bindStatusCode != 200) {
            return
        }
        
        guard let publishStatusCode = try? await FeedWebService.publishContent(contentId: post.id) else {
            return
        }
        
        if (publishStatusCode != 201) {
            return
        }
        
        // Remove it from view
        
        withAnimation {
            drafts.posts.removeAll(where: { $0.id == post.id })
        }
    }
    
    func declinePostAction() async -> Void {
        guard let statusCode = try? await FeedWebService.removeContent(contentId: post.id) else {
            return
        }
        
        if (statusCode != 200) {
            return
        }
        
        // Remove it from view
        
        withAnimation {
            drafts.posts.removeAll(where: { $0.id == post.id })
        }
    }
}

struct PostInDraftView_Previews: PreviewProvider {
    static var previews: some View {
        PostInDraftView(post: Post(), isLoading: .constant(false))
            .environmentObject(DraftFeedViewModel())
            .environmentObject(WalletViewModel())
    }
}
