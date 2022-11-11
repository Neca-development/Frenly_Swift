//
//  SmartContractService.swift
//  Frenly
//
//  Created by Владислав on 10.11.2022.
//

import Foundation

import Web3
import Web3ContractABI
import PromiseKit

final class SmartContractService {
    private var web3: Web3!
    private var contract: DynamicContract!
    
    init () {
        web3 = Web3(rpcURL: Constants.MUMBAI_RPC_URL)
        
        do {
            let contractAddress = try EthereumAddress(hex: Constants.MUMBAI_LENS_CONTRACT_ADDRESS, eip55: true)
            let contractJsonABI = loadJson(filename: "LensHubAbi")!
            
            contract = try web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
        } catch {
            print(error)
        }
    }
    
    func lensIdByWalletAddress(walletAddress: String) async -> String? {
        await withCheckedContinuation { continuation in
            firstly {
                try contract["tokenOfOwnerByIndex"]!(
                    EthereumAddress(hex: walletAddress, eip55: true),
                    0
                ).call()
            }.done { outputs in
                let lensId = outputs[""] as? BigUInt
                let decimal = Int(lensId!.description, radix: 10)!
                let hex = String(decimal, radix: 16)
                
                continuation.resume(returning: "0x\(hex)")
            }.catch { error in
                print(error)
                continuation.resume(returning: nil)
            }
        }
    }
}

func loadJson(filename fileName: String) -> Data? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("error:\(error)")
        }
    }
    
    return nil
}
