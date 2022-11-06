//
//  UserEditView.swift
//  Frenly
//
//  Created by Владислав on 03.11.2022.
//

import SwiftUI

struct UserEditView: View {
    @EnvironmentObject private var user: UserViewModel
    
    @EnvironmentObject private var wallet: WalletViewModel
    @EnvironmentObject private var auth: AuthViewModel
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    
    @FocusState var descriptionFocus: Int?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea().opacity(0.001)
                .onTapGesture { descriptionFocus = nil }
        
        VStack {
            AsyncImage(
                url: URL(string: "\(Constants.AVATAR_IMAGES_URL)/\(user.user.avatar)")!
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } else if phase.error != nil {
                    Image("Image_MockAvatar")
                        .resizable()
                } else {
                    ProgressView()
                }
            }
            .frame(
                width: 80,
                height: 80,
                alignment: .center
            )
            
            Button {
                showImagePicker = true
            } label: {
                Text("Upload new avatar")
                    .font(.system(size: 20, weight: .regular, design: .rounded))
                    .foregroundColor(.blue)
                    .padding(.bottom)
            }
            .fullScreenCover(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .onChange(of: selectedImage) { _ in loadImage() }
            
            Divider()
            
            Text("Username")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(
                    width: UIScreen.main.bounds.width * 0.8,
                    alignment: .leading
                )
            
            TextField("", text: $user.user.username) {
                if (user.user.username.count == 0) {
                    user.user.username = "FrenlyUser"
                }
            }
            .font(.system(size: 18, weight: .regular, design: .rounded))
            .padding(.leading, 10)
            .frame(
                width: UIScreen.main.bounds.width * 0.8,
                height: 35
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.blue))
            
            Text("Description")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(
                    width: UIScreen.main.bounds.width * 0.8,
                    alignment: .leading
                )
            
            ZStack(alignment: .topLeading) {
                if user.user.description.isEmpty {
                    Text("Tell about yourself...")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .padding(.top, 10)
                        .padding(.leading, 5)
                }

                TextEditor(text: $user.user.description)
                    .focused($descriptionFocus, equals: 1)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .opacity(user.user.description.isEmpty ? 0.25 : 1)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.blue))
            }
            .frame(
                width: UIScreen.main.bounds.width * 0.8,
                height: 50
            )
            
            Button {
                logout()
            } label: {
                Text("LOG OUT")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .frame(
                        width: UIScreen.main.bounds.width * 0.6,
                        height: UIScreen.main.bounds.height * 0.08
                    )
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(40)
            }
            .padding(.top)
        }
        }
    }
    
    private func loadImage() {
        guard let inputImage = selectedImage else { return }
        
        Task { await user.uploadImage(image: inputImage) }
    }
    
    private func logout() {
        wallet.disconnect()
        
        AuthTokenHelper.clearTokens()
        LensTokenHelper.clearTokens()
        
        auth.status = .unauthorized
        wallet.wcStatus = .disconnected
    }
}

struct UserEditView_Previews: PreviewProvider {
    static var previews: some View {
        UserEditView()
            .environmentObject(UserViewModel())
    }
}
