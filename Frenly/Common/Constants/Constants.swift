//
//  Constants.swift
//  Frenly
//
//  Created by Владислав on 01.11.2022.
//

import Foundation

class Constants {
    static let SERVER_URL = "https://gm.frenly.cc/rest"
    static let LENS_URL = "https://api-mumbai.lens.dev"
    
    static let TOKEN_IMAGES_URL = "https://gm.frenly.cc/rest/token-images"
    static let AVATAR_IMAGES_URL = "https://gm.frenly.cc/rest/avatars"
    
    static let ACCESS_TOKEN_KEY = "access_token"
    static let REFRESH_TOKEN_KEY = "refresh_token"
    
    static let LENS_ACCESS_TOKEN_KEY = "lens_access_token"
    static let LENS_REFRESH_TOKEN_KEY = "lens_refresh_token"
    
    static let WC_SESSION_KEY = "wc_session"
    static let WC_WALLET_TYPE_KEY = "wc_wallet_type"
    
    static let ETH_NULL_ADDRESS = "0x0000000000000000000000000000000000000000"
    
    static let MUMBAI_CHAIN_ID = "0x13881"
    static let MUMBAI_CHAIN_ID_DECIMAL = 80001
    
    static let MUMBAI_RPC_URL = "https://polygon-mumbai.g.alchemy.com/v2/GHk7QUctHo69C1VGlveQ6cSu1-664KaS"
    static let MUMBAI_LENS_CONTRACT_ADDRESS = "0x60Ae865ee4C725cd04353b5AAb364553f56ceF82"
    
    static let TOPIC_POST_CREATED = "0xc672c38b4d26c3c978228e99164105280410b144af24dd3ed8e4f9d211d96a50"
    static let TOPIC_MIRROR_CREATED = "0x9ea5dedb85bd9da4e264ee5a39b7ba0982e5d4d035d55edfa98a36b00e770b5a"
}
