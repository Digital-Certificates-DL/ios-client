//
//  ReposController.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 17.05.2023.
//

import Foundation

protocol ReposManagerProvider: AnyObject {
    var certificatesRepo: CertificatesRepoProvider { get }
}

class ReposManager: ReposManagerProvider {
    let certificatesRepo: CertificatesRepoProvider
    
    init(apiManager: ApiClientProvider) {
        self.certificatesRepo = CertificatesRepo(apiManager: apiManager)
    }
    
}
