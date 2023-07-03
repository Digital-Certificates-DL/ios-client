//
//  Secp256k1Manager.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 22.05.2023.
//

import Foundation
import secp256k1
import Secp256k1Swift
import CryptoKit
import Base58String
import ripemd160_Swift

fileprivate enum RecoverPublicKeyError: Error {
    case failedToRepresentMessageInUtf8
    case failedToRepresentRecoverySignatureInBase64
    case failedToRepresentDataToHexString
}

fileprivate enum VerificationSignatureError: Error {
    case failedToBase58DecodeAddress
    case failedToRepresentMessageInUtf8
    case failedToRepresentRecoverableSignatureInBase64
    case failedToRepresentHexToData
}

fileprivate enum DecodeSignatureError: Error {
    case invalidSignatureLength
    case invalidSignatureParameter  // recid
}

fileprivate enum SegwitType {
    case p2shP2wpkh
    case p2wpkh
}

fileprivate struct SignatureData {
    let compressed: Bool
    let segwitType: SegwitType?
    let recovery: Int
    let signature: Data
}

func sha256(_ data: Data) -> Data {
    return Data(CryptoKit.SHA256.hash(data: data))
}

func hash256(_ buffer: Data) -> Data {
    return sha256(sha256(buffer))
}

func hash160(_ buffer: Data) -> Data {
    return Data(RIPEMD160.hash(sha256(buffer)))
}


class Secp256k1Manager {
    
    func recoverPublicKeyMagic(
        _ message: String,
        _ recoverySignature: String
    ) throws -> String {
        guard let messageData = message.data(using: .utf8) else {
            throw RecoverPublicKeyError.failedToRepresentMessageInUtf8
        }
        
        guard let recoverySignatureData = Data(base64Encoded: recoverySignature) else {
            throw RecoverPublicKeyError.failedToRepresentRecoverySignatureInBase64
        }
        
        let publicKeyData = try recoverPublicKey(messageData, recoverySignatureData)
        
        let hexStringPublicKey = String.init(utf8DataToHexString: publicKeyData)
        
        return hexStringPublicKey
    }
    
    func recoverPublicKey(
        _ message: Data, // utf-8 presented
        _ recoverySignature: Data // 65 bytes (recoverySignature[0] - recId, other bytes - signature). Base64 coding
    ) throws -> Data {
        let messageHash = magicHash(message)
        let parsed = try decodeSignature(buffer: recoverySignature)
        let recoveredPublicKey = try Secp256k1.recoverCompact(
            msg: messageHash.bytes,
            sig: parsed.signature.bytes,
            recID: Secp256k1.RecoveryID(parsed.recovery),
            compression: .uncompressed)
        return Data(bytes: recoveredPublicKey, count: recoveredPublicKey.count)
    }
    
    func verifySignatureMagic(
        _ message: String,
        _ recoverableSignature: String,
        _ address: String
    ) throws -> Bool {
        guard let messageData = message.data(using: .utf8) else {
            throw VerificationSignatureError.failedToRepresentMessageInUtf8
        }
        
        guard let recoverableSignatureData = Data(base64Encoded: recoverableSignature) else {
            throw VerificationSignatureError.failedToRepresentRecoverableSignatureInBase64
        }
        
        return try verifySignature(messageData, recoverableSignatureData, address)
    }
    
    func verifySignature(
        _ message: Data,
        _ recoverySignature: Data,
        _ address: String
    ) throws -> Bool {
        let publicKey = try recoverPublicKey(message, recoverySignature)
        // in future for all bitcoin addresses
//        let parsed = try decodeSignature(buffer: recoverySignature)
        let hashedPublicKey = hash160(publicKey)
        let versionByteAndHashedPublicKeyData = Data(hexString: "00")! + hashedPublicKey
        let hashedPublicKeyWithVersionByte = hash256(versionByteAndHashedPublicKeyData)
        let checkSum = Data(hashedPublicKeyWithVersionByte[0...3])
        let addressHex = hashedPublicKey + checkSum
        let resultAddress = String(base58Encoding: addressHex)
        return resultAddress == address.popFirst()
    }
    
    private func decodeSignature(
        buffer: Data
    ) throws -> SignatureData {
        guard buffer.count == 65 else {
            throw DecodeSignatureError.invalidSignatureLength
        }
        
        let flagByte = Int(buffer[0]) - 27
        guard flagByte <= 15 && flagByte >= 0 else {
            throw DecodeSignatureError.invalidSignatureParameter
        }
        
        let compressed = (flagByte & 12) != 0
        var segwitType: SegwitType? = nil
        
        if (flagByte & 8) == 0 {
            segwitType = nil
        } else if (flagByte & 4) == 0 {
            segwitType = .p2shP2wpkh
        } else {
            segwitType = .p2wpkh
        }
        
        let recovery = flagByte & 3
        let signature = buffer.subdata(in: 1..<buffer.count)
        
        return SignatureData(compressed: compressed, segwitType: segwitType, recovery: recovery, signature: signature)
    }

    private func magicHash(
        _ message: Data,
        messagePrefix: String? = "\u{0018}Bitcoin Signed Message:\n"
    ) -> Data {
        let messagePrefixData: Data
        if let prefix = messagePrefix {
            messagePrefixData = Data(prefix.utf8)
        } else {
            messagePrefixData = Data()
        }
        
        var buffer = Data()
        buffer.append(messagePrefixData)
        buffer.append(VarInt(UInt64(message.count)).data)
        buffer.append(message)
        
        return hash256(buffer)
    }
                                          
    func test3() {
        let message = "03.04.2023 Daria Hudemchuk Beginner at theoretical aspects blockchain technology"
        let signature = "G1EB37Vx8llI+7T0ZFhXN3h6QE30ah39DSECDfKbLgc0NCedqwHirLlvnTVKYLD1jl4BIbyMXQ0jBGmWuWHFvM8="
        let address = "1BooKnbm48Eabw3FdPgTSudt9u4YTWKBvf"
        print(try! verifySignatureMagic(message, signature, address) == true)
    }
}
