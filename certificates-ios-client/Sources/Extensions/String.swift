import Foundation

extension String {
    func isHexString() -> Bool {
        let hexCharacterSet = CharacterSet(charactersIn: "0123456789abcdefABCDEF")
        let invalidCharacterSet = hexCharacterSet.inverted
        
        let filteredString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if the string contains only valid hexadecimal characters
        if filteredString.rangeOfCharacter(from: invalidCharacterSet) == nil {
            return true
        }
        
        return false
    }
}

