import Foundation

// This realization was gotten from js library and implemented to swift with ChatGPT and some changes by my hands =)
// https://github.com/cryptocoinjs/bs58

class Base58JSRewrite {

    enum DecodeBase58Error: Error {
        case sourceIsEmpty
        case invalidValue
        case nonZeroCarry
    }
    
    // by default uses bitcoin alphavite
    init?(alphavite: String = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz") {
        self.characterSet = alphavite
        self.leader = characterSet.first ?? Character("0")
        if alphavite.isEmpty { return }
    }
    
    let characterSet: String
    let leader: Character // first character of character set
    lazy var base = Double(characterSet.count)
    lazy var factor = log(base) / log(256.0)
    lazy var baseMap: [UInt8] = {
        var bm = [UInt8](repeating: 255, count: 256)
        for (i, char) in self.characterSet.enumerated() {
            var x = String(char)
            let xc = x.utf8CString[0]
            var index: Int = Int(xc)
            if bm[index] != 255 {
                return []
            }
            bm[index] = UInt8(i)
        }
        return bm
    }()
    
    private func decodeUnsafe(source: String) throws -> [UInt8] {
        if source.isEmpty { throw DecodeBase58Error.sourceIsEmpty }
        
        var psz = 0
        var zeroes = 0
        var length = 0
        
        while psz < source.count && source.characterAtIndex(index: psz) == characterSet.characterAtIndex(index: 0) {
            zeroes += 1
            psz += 1
        }
        
        let size = ((source.count - psz) * 733 / 1000) + 1
        var b256 = [UInt8](repeating: 0, count: size)
        
        while psz < source.count {
            let carry = Int(baseMap[Int(source[source.index(source.startIndex, offsetBy: psz)].asciiValue!)])
            if carry == 255 { throw DecodeBase58Error.invalidValue }
            
            var i = 0
            var it3 = size - 1
            var carrySum = carry
            
            while (carrySum != 0 || i < length) && it3 >= 0 {
                carrySum += Int(base) * Int(b256[it3])
                b256[it3] = UInt8(carrySum % 256)
                carrySum /= 256
                it3 -= 1
                i += 1
            }
            
            if carrySum != 0 {
                throw DecodeBase58Error.nonZeroCarry
            }
            
            length = i
            psz += 1
        }
        
        var it4 = size - length
        while it4 < size && b256[it4] == 0 {
            it4 += 1
        }
        
        var vch = [UInt8](repeating: 0, count: zeroes + (size - it4))
        vch[..<zeroes].indices.forEach { vch[$0] = 0x00 }

        var j = zeroes
        while it4 < size {
            vch[j] = b256[it4]
            j += 1
            it4 += 1
        }
        
        return vch
    }
    
    public func decode(_ source: String) -> [UInt8] {
        do {
            let buffer = try decodeUnsafe(source: source)
            return buffer
        } catch DecodeBase58Error.invalidValue {
            print("Error from line (if carry = 255)")
        } catch DecodeBase58Error.nonZeroCarry {
            print("Error from line (if carrySum != 0)")
        } catch DecodeBase58Error.sourceIsEmpty {
            print("Error from line (if source.isEmpty)")
        } catch {
            print("Something went wrong")
        }
        return []
    }
}

extension String {
    func characterAtIndex(index: Int) -> String? {
        var cur = 0
        for char in self {
            if cur == index {
                return String(char)
            }
            cur += 1
        }
        return nil
    }
}
