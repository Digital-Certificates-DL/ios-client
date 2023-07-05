//
//  ApiClient.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 16.05.2023.
//

import Foundation
import Alamofire

protocol ApiClientProvider: AnyObject {
    var certificatesApi: CertificatesApiProvider { get }
    var transactionsAPI: TransactionsApiProvider { get }
}

class ApiClient: ApiClientProvider {
    let certificatesApi: CertificatesApiProvider
    let transactionsAPI: TransactionsApiProvider

    private let configuration: Config
    
    init(configuration: Config) {
        self.configuration = configuration
        self.certificatesApi = CertificatesAPI(configuration: configuration)
        self.transactionsAPI = TransactionsAPI(configuration: configuration)
    }
}
