//
//  TransactionsAPI.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 18.05.2023.
//

import Alamofire

protocol TransactionsApiProvider: AnyObject {
    func getTransactionById(_ txHash: String) async -> Data?
}

class TransactionsAPI: TransactionsApiProvider {
    
    fileprivate enum Endpoints: String {
        case tx = "tx/"
    }
    
    private let configuration: Config

    init(configuration: Config) {
        self.configuration = configuration
    }
    
    func getTransactionById(_ txHash: String) async -> Data? {
        await withUnsafeContinuation { continuation in
            print(configuration.bitcoinScanApiUrl + Endpoints.tx.rawValue + txHash)
            AF.request(configuration.bitcoinScanApiUrl + Endpoints.tx.rawValue + txHash).response { result in
                switch result.result {
                case .success(let data):
                    guard let data else {
                        continuation.resume(returning: nil)
                        return
                    }
                    continuation.resume(returning: data)
                case .failure(_):
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
