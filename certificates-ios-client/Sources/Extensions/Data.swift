import Foundation

extension Data {
    init?(hexString: String) {
        var hex = hexString
        if hex.count % 2 != 0 {
            hex = "0" + hex
        }
        self.init(capacity: hex.count / 2)
        
        var index = hex.startIndex
        while index < hex.endIndex {
            let byteString = hex[index..<hex.index(index, offsetBy: 2)]
            guard let byte = UInt8(byteString, radix: 16) else {
                return nil
            }
            append(byte)
            index = hex.index(index, offsetBy: 2)
        }
    }
}
