//
//  Transaction.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 18.05.2023.
//

import Foundation

struct Transaction: Codable {
    struct Status: Codable {
        let blockHash: String?
        let blockHeight: Int?
        let blockTime: Int?
        let confirmed: Bool
        
        enum CodingKeys: String, CodingKey {
            case blockHash = "block_hash"
            case blockHeight = "block_height"
            case blockTime = "block_time"
            case confirmed
        }
    }

    struct PrevOut: Codable {
        let scriptPubKey: String
        let scriptPubKeyAddress: String?
        let scriptPubKeyAsm: String
        let scriptPubKeyType: String
        let value: Int
        
        enum CodingKeys: String, CodingKey {
            case scriptPubKey = "scriptpubkey"
            case scriptPubKeyAddress = "scriptpubkey_address"
            case scriptPubKeyAsm = "scriptpubkey_asm"
            case scriptPubKeyType = "scriptpubkey_type"
            case value
        }
    }

    struct Vin: Codable {
        let isCoinbase: Bool
        let prevOut: PrevOut
        let scriptSig: String
        let scriptSigAsm: String
        let sequence: Int
        let txid: String
        let vout: Int
        let witness: [String]
        
        enum CodingKeys: String, CodingKey {
            case isCoinbase = "is_coinbase"
            case prevOut = "prevout"
            case scriptSig = "scriptsig"
            case scriptSigAsm = "scriptsig_asm"
            case sequence
            case txid
            case vout
            case witness
        }
    }

    struct Vout: Codable {
        let scriptPubKey: String
        let scriptPubKeyAddress: String?
        let scriptPubKeyAsm: String
        let scriptPubKeyType: String
        let value: Int
        
        enum CodingKeys: String, CodingKey {
            case scriptPubKey = "scriptpubkey"
            case scriptPubKeyAddress = "scriptpubkey_address"
            case scriptPubKeyAsm = "scriptpubkey_asm"
            case scriptPubKeyType = "scriptpubkey_type"
            case value
        }
    }

    let fee: Int
    let locktime: Int
    let size: Int
    let status: Status
    let txid: String
    let version: Int
    let vin: [Vin]
    let vout: [Vout]
    let weight: Int
}
