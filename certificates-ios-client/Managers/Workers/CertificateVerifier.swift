//
//  CertificateVerifier.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 18.05.2023.
//

import UIKit
import secp256k1

protocol CertificateVerifierProtocol: AnyObject {
    func parseQrCode(_ qrCodeString: String) -> QrData?
    func isValidQrCode(_ qrData: QrData) -> Bool
    func validateCertificate(
        _ qrData: QrData
    ) async -> QrDataValidated
}

class CertificateVerifier: CertificateVerifierProtocol {
    let certificateProvider: CertificateProviderProtocol
    let transactionProvider: TransactionProviderProtocol
    private let requiredKeys = ["message", "address", "signature"]

    
    init(certificateProvider: CertificateProviderProtocol, transactionProvider: TransactionProviderProtocol) {
        self.certificateProvider = certificateProvider
        self.transactionProvider = transactionProvider
    }
    
    func parseQrCode(_ qrCodeString: String) -> QrData? {
        guard let keyValue = getDictionaryFromString(qrCodeString) else { return nil }
        let qrData = QrData(
            message: keyValue["message"] ?? "",
            address: keyValue["address"] ?? "",
            signature: keyValue["signature"] ?? "",
            certificatePage: keyValue["certificate page"]
        )
        return qrData
    }
    
    func isValidQrCode(_ qrData: QrData) -> Bool {
        let messageIsNotEmpty = !qrData.message.isEmpty
        let addressIsNotEmpty = !qrData.address.isEmpty
        let signatureIsNotEmpty = !qrData.signature.isEmpty
        return messageIsNotEmpty && addressIsNotEmpty && signatureIsNotEmpty
    }
    
    func validateCertificate(
        _ qrData: QrData
    ) async -> QrDataValidated {
        var qrDataValidated = QrDataValidated(qrData: qrData, date: "", certificateIsValid: false)
        
        // checkSignature()
    
        guard let certificate = await certificateProvider.getCertificate(with: qrDataValidated.signature) else {
            return qrDataValidated
        }
        
        if certificate.txHash == "–" {
            qrDataValidated.certificateIsValid = true
            return qrDataValidated
        }
        
        await transactionProvider.provideTransactionWithId(txHash: certificate.txHash)
        
        let timestamp = transactionProvider.transaction?.status.blockTime
        qrDataValidated.date = getDate(timestamp: timestamp) ?? ""

        guard let timeStamping = getTimestampingField(transaction: transactionProvider.transaction) else {
            return qrDataValidated
        }

        if qrData.message.contains(timeStamping) {
            qrDataValidated.certificateIsValid = true
        }
        
        return qrDataValidated
    }

}

private extension CertificateVerifier {
    
    
    func getDate(timestamp: Int?) -> String? {
        guard let timestamp = timestamp else { return nil }
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dayTimePeriodFormatter.string(from: date)
        return dateString
    }
     
    func getTimestampingField(transaction: Transaction?) -> String? {
        let outputs = transaction?.vout
        let opReturn = outputs?.first { output in
            output.scriptPubKeyAddress == nil
        }
        guard let opReturn = opReturn else { return nil }
        guard var bytes = try? opReturn.scriptPubKey.bytes else { return nil }
        bytes = Array(bytes.dropFirst(2))
        let hexMessage = String(bytes: bytes)
        return String(hexString: hexMessage)
    }
    
    private func getDictionaryFromString(_ qrString: String) -> [String: String]? {
        var keyValueDictionary: [String: String] = [:]
        for requiredKey in requiredKeys {
            if !qrString.contains(requiredKey) { return nil }
        }
        let formattedString = deleteNewLineAfterKey(qrString)
        let keyValues = formattedString.split(separator: "\n")
        for keyValue in keyValues {
            let key = String(keyValue.split(separator: ":", maxSplits: 1)[0])
            let value = String(keyValue.split(separator: ":", maxSplits: 1)[1])
            keyValueDictionary[key] = value
        }
        return keyValueDictionary
    }
    
    private func deleteNewLineAfterKey(_ qrString: String) -> String {
        var findColon = false
        var resultString = ""
        var findedTimes = 0
        for character in qrString {
            if findColon {
                resultString.append("")
                findColon = false
                findedTimes = 0
                continue
            }
            if character == ":" && findedTimes == 0 {
                findColon = true
                findedTimes += 1
            }
            resultString.append(character)
        }
        return resultString
    }
}
