//
//  VarInt.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 29.06.2023.
//

import Foundation

struct VarInt {
    let value: UInt64
    
    init(_ value: UInt64) {
        self.value = value
    }
    
    var data: Data {
        var buffer: [UInt8] = []
        var value = self.value
        repeat {
            var byte = UInt8(value & 0x7F)
            value >>= 7
            if value != 0 {
                byte |= 0x80
            }
            buffer.append(byte)
        } while value != 0
        return Data(buffer)
    }
}
