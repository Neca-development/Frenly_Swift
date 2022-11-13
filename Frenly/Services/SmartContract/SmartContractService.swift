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
import CryptoSwift

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
    
    // Common utils
    
    func lensIdByWalletAddress(walletAddress: String) async -> String? {
        await withCheckedContinuation { continuation in
            firstly {
                try contract["tokenOfOwnerByIndex"]!(
                    EthereumAddress(hex: walletAddress, eip55: false),
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
    
    func getTransactionReceipt(txHash: String) async -> EthereumTransactionReceiptObject?? {
        await withCheckedContinuation { continuation in
            let hashBytes = Array<UInt8>.init(hex: txHash)
                
            web3.eth.getTransactionReceipt(transactionHash: EthereumData(hashBytes), response: { result in
                continuation.resume(returning: result.result)
            })
        }
    }
    
    // Publications
    
    func createPostABIData(params: CreatePostTypedDataMutation.Data.CreatePostTypedData.TypedData) async -> String? {
//        guard let splittedSignature = splitSignature(signature: signature) else {
//            return nil
//        }

        let params = SolidityTuple(
            SolidityWrappedValue.uint(BigUInt(params.value.profileId.dropFirst(2), radix: 16)!),
            SolidityWrappedValue.string(params.value.contentURI),
            SolidityWrappedValue.address(try! EthereumAddress(hex: params.value.collectModule, eip55: false)),
            SolidityWrappedValue.bytes(Data(hex: params.value.collectModuleInitData)),
            SolidityWrappedValue.address(try! EthereumAddress(hex: params.value.referenceModule, eip55: false)),
            SolidityWrappedValue.bytes(Data(hex: params.value.referenceModuleInitData))
                
//            SolidityWrappedValue.uint(UInt8(splittedSignature.v.dropFirst(2), radix: 16)!),
//            SolidityWrappedValue.fixedBytes(Data(hex: splittedSignature.r)),
//            SolidityWrappedValue.fixedBytes(Data(hex: splittedSignature.s)),
//            SolidityWrappedValue.uint(BigUInt(signParams.value.deadline, radix: 10)!)
        )
        
        guard let ethData = contract["post"]!(params).encodeABI() else {
            return nil
        }
        
        return ethData.hex()
    }
    
    func splitSignature(signature: String) -> SplittedSignature? {
        var bytes = Array<UInt8>.init(hex: signature)
        
        var v = Byte()

        var s: [Byte] = []
        var r: [Byte] = []

        // Get the r, s and v
        if (bytes.count == 64) {
            // EIP-2098; pull the v from the top bit of s and clear it
            v = 27 + (bytes[32] >> 7)
            bytes[32] &= 0x7f

            r += bytes[0...31]
            s += bytes[32...63]
        } else if (bytes.count == 65) {
            r += bytes[0...31]
            s += bytes[32...63]

            v = bytes[64];
        } else {
            print("invalid signature string")
            return nil
        }


        // Allow a recid to be used as the v
        if (v < 27) {
            if (v == 0 || v == 1) {
                v += 27;
            } else {
                print("signature invalid v byte")
                return nil
            }
        }

        
        return SplittedSignature(
            v: "0x\(String(format: "%02X", v))",
            r: "0x\(r.map{ String(format: "%02X", $0) }.joined(separator: ""))",
            s: "0x\(s.map{ String(format: "%02X", $0) }.joined(separator: ""))"
        )
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

struct SplittedSignature {
    var v: String
    var r: String
    var s: String
}
