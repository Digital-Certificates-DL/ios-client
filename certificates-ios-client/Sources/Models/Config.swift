//
//  Config.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 17.05.2023.
//

import Foundation

fileprivate enum ConfigKeys: String {
    case certificatesUrl
    case bitcoinScanApiUrl
}

struct Config {
    let certificatesUrl: String
    let bitcoinScanApiUrl: String
    
    init() {
        guard let path: String = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let configuration: NSDictionary = NSDictionary(contentsOfFile: path) else {
            fatalError("failed to find Config.plist")
        }
        
        self.certificatesUrl = configuration[.certificatesUrl]
        self.bitcoinScanApiUrl = configuration[.bitcoinScanApiUrl]
    }
}

fileprivate extension NSDictionary {
    subscript(_ key: ConfigKeys) -> String {
        return self[key.rawValue] as! String
    }
}
