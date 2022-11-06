//
//  UserViewModel.swift
//  Frenly
//
//  Created by Владислав on 03.11.2022.
//

import Foundation
import JWTDecode
import UIKit

@MainActor
class UserViewModel: ObservableObject {
    @Published var user = User()
    
    func fetchUser() async -> Void {
        guard let accessToken = AuthTokenHelper.readAccessToken() else { return }
        guard let jwt = try? decode(jwt: accessToken) else { return }
        
        let walletAddress = jwt.body["walletAddress"] as! String
        
        
        guard let response = try? await UserWebService.getUserInfo(walletAddress: walletAddress) else { return }
        
        user.avatar = response.data.avatar ?? ""
        user.username = response.data.username ?? UtilsService.User.nameFromWalletAddress(walletAddress: walletAddress)
        user.description = response.data.description ?? ""
    }
    
    func uploadImage(image: UIImage) async -> Void {
        guard let avatar = Media(withImage: image, forKey: "avatar") else { return }
        let _ = try? await UserWebService.uploadAvatart(avatar: avatar)        
        
        guard let accessToken = AuthTokenHelper.readAccessToken() else { return }
        guard let jwt = try? decode(jwt: accessToken) else { return }
        
        let walletAddress = jwt.body["walletAddress"] as! String
        
        
        guard let response = try? await UserWebService.getUserInfo(walletAddress: walletAddress) else { return }
        
        user.avatar = response.data.avatar ?? ""
    }
    
    func updateUserInfo() async -> Void {
        let _ = try? await UserWebService.updateUserInfo(username: user.username, description: user.description)
    }
}
