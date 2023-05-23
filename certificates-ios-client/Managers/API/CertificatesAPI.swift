//
//  CertificatesAPI.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 18.05.2023.
//

import Alamofire

protocol CertificatesApiProvider: AnyObject {
    func getCertificates() async -> Data?
}

class CertificatesAPI: CertificatesApiProvider {
    private let configuration: Config

    init(configuration: Config) {
        self.configuration = configuration
    }
    
    func getCertificates() async -> Data? {
        await withUnsafeContinuation { continuation in
            AF.request(configuration.certificatesUrl, method: .get).response { result in
                switch result.result {
                case .success(let data):
                    guard let data = data else {
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
