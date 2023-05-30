//
//  Secp256k1Manager.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 22.05.2023.
//

import Foundation
import secp256k1
import CryptoKit


class Secp256k1Manager {
    
    func getRecoverableSignature(
        base64StringRecoverableSignature: String
    ) -> secp256k1_ecdsa_recoverable_signature {
        let data = Data(base64Encoded: base64StringRecoverableSignature)!


        return getRecoverableSignaturePrivate(base64StringRecoverableSignature: data)
    }
    
    func recoverPublicKey(
        _ recoverableSignature: String,
        _ message: String
    ) -> secp256k1_pubkey {
        let signature = getRecoverableSignature(base64StringRecoverableSignature: recoverableSignature)
        let messageHash = SHA256.hash(data: message.data(using: .utf8)!)
        return recoverPublicKeyPrivate(signature, messageHash.bytes)
    }
    
    func convertRecoverableSignature(
        _ recoverableSignature: secp256k1_ecdsa_recoverable_signature
    ) -> secp256k1_ecdsa_signature {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_NONE))!
        var recoverableSignature = recoverableSignature
        var signature = secp256k1_ecdsa_signature()
        if secp256k1_ecdsa_recoverable_signature_convert(context, &signature, &recoverableSignature) == 0 {
            fatalError("failed to convert signature")
        }
        secp256k1_context_destroy(context)
        return signature
    }
    
    func hashSha256(_ message: String) -> [UInt8] {
        let hashedMessage = SHA256.hash(data: message.data(using: .utf8)!)
        return hashedMessage.bytes
    }
    
    func verifySignature(
        _ recoverableSignature: String,
        _ message: String
    ) -> Bool {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_VERIFY))!
        let recoverableSignature = getRecoverableSignature(base64StringRecoverableSignature: recoverableSignature)
        let message = hashSha256(message)
        var publicKey = recoverPublicKeyPrivate(recoverableSignature, message)
        var signature = convertRecoverableSignature(recoverableSignature)
        let isValid = secp256k1_ecdsa_verify(context, &signature, message, &publicKey) != 0
        secp256k1_context_destroy(context)
        return isValid
    }
    
    
    
    private func getRecoverableSignaturePrivate(
        base64StringRecoverableSignature: Data
    ) -> secp256k1_ecdsa_recoverable_signature {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_NONE))!
        var signature = secp256k1_ecdsa_recoverable_signature()
        var bytes = base64StringRecoverableSignature.bytes
        var header = bytes[0] & 0xFF
//        print(header)
        var recId = header - 27
        bytes = Array(bytes[1...64])
        bytes.append(recId)
//        var header = bytes[64]
//        if header >= 31 {
//            header -= 4
//        }
//
        
//        print(recId)
//        print(bytes)
//        bytes = Array(bytes[1...64])
//        print(bytes)
//        print(bytes.count)
//        var r = bytes[0...32]
//        var s = bytes[33...64]
//        let rR =
        
//        secp256k1_ecdsa_recoverable_signature_load(context, <#T##secp256k1_scalar#>, <#T##secp256k1_scalar#>, <#T##Int32#>, <#T##secp256k1_ecdsa_recoverable_signature#>)
//        print(recId)
//        secp256k1_ecdsa_recoverable_signature
//        let recoveryId: Int32 = 0

        if (secp256k1_ecdsa_recoverable_signature_parse_compact(context, &signature, bytes, Int32(recId)) == 0) {
            print("error there")
        }
        secp256k1_context_destroy(context)
        return signature
    }
    
    private func recoverPublicKeyPrivate(
        _ recoverableSignature: secp256k1_ecdsa_recoverable_signature,
        _ message: [UInt8]
    ) -> secp256k1_pubkey {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_NONE))!
        var publicKey = secp256k1_pubkey()
        
        var recoverableSignature = recoverableSignature
        if secp256k1_ecdsa_recover(context, &publicKey, &recoverableSignature, message) == 0 {
            fatalError("error")
        }
        secp256k1_context_destroy(context)
        return publicKey
    }
        
    private func verifySignature(
        _ signature: secp256k1_ecdsa_signature,
        _ publicKey: secp256k1_pubkey,
        _ messageHash: [UInt8]
    ) -> Bool {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_VERIFY))!
        var signature = signature
        var publicKey = publicKey
        let isValid = secp256k1_ecdsa_verify(context, &signature, messageHash, &publicKey) != 0
        secp256k1_context_destroy(context)
        return isValid
    }
    //
//    1b5101dfb571f25948fbb4f464585737787a404df46a1dfd0d21020df29b2e073434279dab01e2acb96f9d354a60b0f58e5e0121bc8c5d0d23046996b961c5bccf

    func test() {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_NONE))!
        let recoverySiganture = "G1EB37Vx8llI+7T0ZFhXN3h6QE30ah39DSECDfKbLgc0NCedqwHirLlvnTVKYLD1jl4BIbyMXQ0jBGmWuWHFvM8="
//        let recoverySiganture = "1b5101dfb571f25948fbb4f464585737787a404df46a1dfd0d21020df29b2e073434279dab01e2acb96f9d354a60b0f58e5e0121bc8c5d0d23046996b961c5bccf"
        let message = "03.04.2023 Daria Hudemchuk Beginner at theoretical aspects blockchain technology"
        var res = recoverPublicKey(recoverySiganture, message)
        var bytes = [UInt8](repeating: 0, count: 65)
        var length = 65
        secp256k1_ec_pubkey_serialize(context, &bytes, &length, &res, UInt32(SECP256K1_EC_UNCOMPRESSED))
        print(bytes.count)
//        print(bytes)
        print(String(bytes: bytes))

        secp256k1_context_destroy(context)
//        var hashed = SHA256.hash(data: message.data(using: .utf8)!)
//        var hashedData = Data(bytes: hashed.bytes, count: hashed.bytes.count)
        
//        print(data.count)
//        let randomkey = SECP256K1.generatePrivateKey()
//        let (serialized, raw) = SECP256K1.signForRecovery(hash: hashedData, privateKey: randomkey!)
//        let base64data = Data(base64Encoded: raw!)!
//        print(raw?.bytes)
//        print(String(bytes: raw!.bytes))
//        print(String(data: base64data, encoding: .utf8)!)
//        let signature = SECP256K1.signForRecovery(hash: randomHash, privateKey: randomPrivateKey, useExtraEntropy: false)
//        let data = Data(bytes: raw!.bytes, count: raw!.bytes.count)
//        print(SECP256K1.recoverPublicKey(hash: hashedData, signature: data))
        

//

//        
//        var base64pk = String(bytes: bytes)
//        print(base64pk)
    }
    
    func test3() {
        var context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_NONE))!
        let BITCOIN_SIGNED_MESSAGE_HEADER = "\x18Bitcoin Signed Message:\n"
//        let BITCOIN_SIGNED_MESSAGE_HEADER_DATA = BITCOIN_SIGNED_MESSAGE_HEADER.data(using: .utf8)!
        let BITCOIN_SIGNED_MESSAGE_HEADER_BYTES = BITCOIN_SIGNED_MESSAGE_HEADER_DATA.bytes
        
        let messageData = "03.04.2023 Daria Hudemchuk Beginner at theoretical aspects blockchain technology".data(using: .utf8)!

        var messageBytes = [UInt8]()
        messageBytes.append(UInt8(BITCOIN_SIGNED_MESSAGE_HEADER_BYTES.count))
        messageBytes.append(contentsOf: BITCOIN_SIGNED_MESSAGE_HEADER_BYTES)
        messageBytes.append(contentsOf: messageBytes.bytes)
        
        
        
        var expectedRecoverySignature = Data(base64Encoded: "G1EB37Vx8llI+7T0ZFhXN3h6QE30ah39DSECDfKbLgc0NCedqwHirLlvnTVKYLD1jl4BIbyMXQ0jBGmWuWHFvM8=")!
//        let messageData = "03.04.2023 Daria Hudemchuk Beginner at theoretical aspects blockchain technology".data(using: .utf8)!
        let hashed = SHA256.hash(data: messageData)
        let hashedTwice = SHA256.hash(data: String(bytes: hashed.bytes).data(using: .utf8)!)
        
        let recoverSignature = getRecoverableSignaturePrivate(base64StringRecoverableSignature: expectedRecoverySignature)
        var publicKey = recoverPublicKeyPrivate(recoverSignature, hashedTwice.bytes)
        
        var bytes = [UInt8](repeating: 0, count: 33)
        var length = bytes.count
        print("length:", length)
        
        secp256k1_ec_pubkey_serialize(context, &bytes, &length, &publicKey, UInt32(SECP256K1_EC_COMPRESSED))
        print(String(bytes: bytes))
        secp256k1_context_destroy(context)
//        print(String(bytes: hashed.bytes))
        
        
    }
    
    func test2() {
        var expectedRecoverySignature = Data(base64Encoded: "G1EB37Vx8llI+7T0ZFhXN3h6QE30ah39DSECDfKbLgc0NCedqwHirLlvnTVKYLD1jl4BIbyMXQ0jBGmWuWHFvM8=")!
        var header = expectedRecoverySignature[64] & 0xFF
        
        print(expectedRecoverySignature.bytes.count)
        print(expectedRecoverySignature[0])
        expectedRecoverySignature[0] -= 27
//        print
        print(expectedRecoverySignature)
//        let recoverySignatureBase64String = "G1EB37Vx8llI+7T0ZFhXN3h6QE30ah39DSECDfKbLgc0NCedqwHirLlvnTVKYLD1jl4BIbyMXQ0jBGmWuWHFvM8="
//        let recoverySignatureHex = "1b5101dfb571f25948fbb4f464585737787a404df46a1dfd0d21020df29b2e073434279dab01e2acb96f9d354a60b0f58e5e0121bc8c5d0d23046996b961c5bccf"
//        let message = "03.04.2023 Daria Hudemchuk Beginner at theoretical aspects blockchain technology"
//        let messageData = "We're all Satoshi Nakamoto and a bit of Harold Thomas Finney II.".data(using: .utf8)!
////        let msgHash = SHA256.hash(data: "For this sample, this 63-byte string will be used as input data".data(using: .utf8)!)
////
////        print("bytes:",  String(bytes: msgHash.bytes))
////        let messageData = message.data(using: .utf8)!
//        let recoverySignatureBase64Data = Data(base64Encoded: expectedRecoverySignature)!
////        let recoverySignatureBase64Bytes = try! recoverySignatureHex.bytes
        let recoverySignature = try! secp256k1.Recovery.ECDSASignature(dataRepresentation: expectedRecoverySignature)
//        print(recoverySignature.dataRepresentation.base64EncodedString() == expectedRecoverySignature)
//        let pk = try! secp256k1.Recovery.PublicKey(messageData, signature: recoverySignature)
//        print(pk.dataRepresentation.)
        let messageData = "03.04.2023 Daria Hudemchuk Beginner at theoretical aspects blockchain technology".data(using: .utf8)!
        let publicKey = try! secp256k1.Recovery.PublicKey(messageData, signature: recoverySignature, format: .compressed)
        
        print(String(bytes: publicKey.dataRepresentation))
    }
    
    func testPublicKeyRecovery() {
        
        
        let expectedRecoverySignature = "rPnhleCU8vQOthm5h4gX/5UbmxH6w3zw1ykAmLvvtXT4YGKBoiMaP8eBBF8upN8IaTYmO7+o0Vyhf+cODD1uVgE="
        let expectedPrivateKey = "5f6d5afecc677d66fb3d41eee7a8ad8195659ceff588edaf416a9a17daf38fdd"
        let privateKeyBytes = try! expectedPrivateKey.bytes
        let privateKey = try! secp256k1.Recovery.PrivateKey(dataRepresentation: privateKeyBytes)
        let messageData = "We're all Satoshi Nakamoto and a bit of Harold Thomas Finney II.".data(using: .utf8)!

        let recoverySignature = try! privateKey.signature(for: messageData)

        // Verify the recovery signature matches the expected output
        print(expectedRecoverySignature == recoverySignature.dataRepresentation.base64EncodedString())

        let publicKey = try! secp256k1.Recovery.PublicKey(messageData, signature: recoverySignature)
        print(String(bytes: publicKey.dataRepresentation))


        // Verify the recovered public key matches the expected public key
//        XCTAssertEqual(publicKey.dataRepresentation, privateKey.publicKey.dataRepresentation)
    }
}



//public static ECKey signedMessageToKey(String message, String signatureBase64) throws SignatureException {
//    byte[] signatureEncoded;
//    try {
//        signatureEncoded = Base64.decode(signatureBase64);
//    } catch (RuntimeException e) {
//        // This is what you get back from Bouncy Castle if base64 doesn't decode 🙁
//        throw new SignatureException("Could not decode base64", e);
//    }
//    // Parse the signature bytes into r/s and the selector value.
//    if (signatureEncoded.length < 65)
//        throw new SignatureException("Signature truncated, expected 65 bytes and got " + signatureEncoded.length);
//    int header = signatureEncoded[0] & 0xFF;
//    // The header byte: 0x1B = first key with even y, 0x1C = first key with odd y,
//    //                  0x1D = second key with even y, 0x1E = second key with odd y
//    if (header < 27 || header > 34)
//        throw new SignatureException("Header byte out of range: " + header);
//    BigInteger r = new BigInteger(1, Arrays.copyOfRange(signatureEncoded, 1, 33));
//    BigInteger s = new BigInteger(1, Arrays.copyOfRange(signatureEncoded, 33, 65));
//    ECDSASignature sig = new ECDSASignature(r, s);
//    byte[] messageBytes = formatMessageForSigning(message);
//    // Note that the C++ code doesn't actually seem to specify any character encoding. Presumably it's whatever
//    // JSON-SPIRIT hands back. Assume UTF-8 for now.
//    Sha256Hash messageHash = "Sha256Hash.twiceOf"(messageBytes);
//    boolean compressed = false;
//    if (header >= 31) {
//        compressed = true;
//        header -= 4;
//    }
//    int recId = header - 27;
//    ECKey key = ECKey.recoverFromSignature(recId, sig, messageHash, compressed);
//    if (key == null)
//        throw new SignatureException("Could not recover public key from signature");
//    return key;
//}
