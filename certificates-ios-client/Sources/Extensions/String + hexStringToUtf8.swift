//
//  String + hexStringToUtf8.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 18.05.2023.
//

import Foundation

extension String {
    
    init?(hexString: String) {
        let sanitizedString = hexString
        var byteArray = [UInt8]()
        var index = sanitizedString.startIndex
        while index < sanitizedString.endIndex {
            let byteString = sanitizedString[index..<sanitizedString.index(index, offsetBy: 2)]
            if let byte = UInt8(byteString, radix: 16) {
                byteArray.append(byte)
            } else { break }
            index = sanitizedString.index(index, offsetBy: 2)
        }
        self.init(bytes: byteArray, encoding: .utf8)
    }
}

extension String {
    init(utf8DataToHexString data: Data) {
        var hexString = ""
        for byte in data.bytes {
            hexString += String(format:"%02x", byte)
        }
        
        self = hexString
    }
}
