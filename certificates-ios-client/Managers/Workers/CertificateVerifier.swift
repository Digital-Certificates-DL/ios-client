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
    private let requiredKeys = ["message:", "address:", "signature:"]

    
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
        guard let isVerified = try? Secp256k1Manager().verifySignatureMagic(qrData.message, qrData.signature, qrData.address), isVerified else {
            return qrDataValidated
        }
        guard let certificate = await certificateProvider.getCertificate(with: qrDataValidated.signature) else {
            return qrDataValidated
        }
        if !isMessageInRightFormat(qrData.message) {
            return qrDataValidated
        }
        if certificate.txHash == "–" {
            qrDataValidated.certificateIsValid = true
            return qrDataValidated
        }
        guard let transaction = await transactionProvider.provideTransactionWithId(txHash: certificate.txHash) else {
            return qrDataValidated
        }
        let blockTime = transaction.status.blockTime
        qrDataValidated.date = getDateString(timestamp: blockTime) ?? ""
        
        guard let qrCodeDateString = getDateFromMessage(qrData.message),
              let blockTime = transaction.status.blockTime else {
            return qrDataValidated
        }
        if !isCertificateDataValid(qrCodeDateString: qrCodeDateString, blockTime: blockTime) {
            return qrDataValidated
        }
        guard let timeStamping = getTimestampingField(transaction: transaction) else {
            return qrDataValidated
        }
        
        if qrData.message.contains(timeStamping) {
            qrDataValidated.certificateIsValid = true
        }
        return qrDataValidated
    }
}

private extension CertificateVerifier {
    
    func isCertificateDataValid(
        qrCodeDateString: String,
        blockTime: Int
    ) -> Bool {
        guard let qrTimeInterval = getTimeInterval(from: qrCodeDateString),
              let blockTimeInterval = getTimeInterval(from: blockTime) else { return false }
        let qrDate = Date(timeIntervalSince1970: qrTimeInterval)
        let blockTime = Date(timeIntervalSince1970: blockTimeInterval)
        return isDifferenceWithinOneMonth(date1: qrDate, date2: blockTime)
    }
    
    func isDifferenceWithinOneMonth(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date1, to: date2)

        // Check if the difference is less than or equal to 1 month
        if let monthDifference = components.month, monthDifference <= 1 {
            return true
        } else {
            return false
        }
    }

    func getTimeInterval(from string: String, dateFormat: String = "dd.MM.yyyy") -> TimeInterval? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat

        if let date = dateFormatter.date(from: string) {
            let timeInterval = date.timeIntervalSince1970
            return timeInterval
        } else {
            return nil
        }
    }
    
    func getTimeInterval(from integer: Int) -> TimeInterval? {
        return TimeInterval(integer)
        
    }

    func getDateFromMessage(_ string: String) -> String? {
        let strings = string.split(separator: " ")
        let date = strings[0]
        return String(date)
    }
    
    func isMessageInRightFormat(_ string: String) -> Bool {
        let pattern = #"^\d{2}\.\d{2}\.\d{4}\s.*"#

        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(location: 0, length: string.count)
            if let match = regex.firstMatch(in: string, options: [], range: range) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func getDateString(timestamp: Int?) -> String? {
        guard let timestamp = timestamp else { return nil }
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dayTimePeriodFormatter.string(from: date)
        return dateString
    }
     
    func getDate(timestamp: Int?) -> Date? {
        guard let timestamp = timestamp else { return nil }
        let date = Date(timeIntervalSince1970: Double(timestamp))
        return date
    }
    
    func getTimestampingField(transaction: Transaction?) -> String? {
        let outputs = transaction?.vout
        let opReturn = outputs?.first { output in
            output.scriptPubKeyAddress == nil
        }
        guard let opReturn = opReturn else { return nil }
        let scriptPubKeyAsm = opReturn.scriptPubKeyAsm
        let words = scriptPubKeyAsm.split(separator: " ")
        for word in words {
            if Opcode(rawValue: String(word)) == nil {
                if let timeStamping = String(hexString: String(word)), !timeStamping.isEmpty {
                    return String(hexString: String(word))
                }
            }
        }
        return nil
    }
    
    func getDictionaryFromString(_ qrString: String) -> [String: String]? {
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
    
    func deleteNewLineAfterKey(_ qrString: String) -> String {
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
