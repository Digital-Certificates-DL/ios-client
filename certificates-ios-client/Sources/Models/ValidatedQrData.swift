//
//  ValidatedQrData.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 19.05.2023.
//

import Foundation

struct QrDataValidated {
    var message: String
    var address: String
    var signature: String
    var certificatePage: String?
    var certificateIsValid: Bool
    var date: String
    
    init(
        message: String,
        address: String,
        signature: String,
        certificatePage: String?,
        date: String,
        certificateIsValid: Bool
    ) {
        self.message = message
        self.address = address
        self.signature = signature
        self.certificatePage = certificatePage
        self.certificateIsValid = certificateIsValid
        self.date = date
    }
    
    init(qrData: QrData, date: String, certificateIsValid: Bool) {
        self.message = qrData.message
        self.address = qrData.address
        self.signature = qrData.signature
        self.certificatePage = qrData.certificatePage
        self.certificateIsValid = certificateIsValid
        self.date = date
    }
}
