//
//  CertificateProvider.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 19.05.2023.
//

import Foundation
import Combine

protocol CertificateProviderProtocol: AnyObject {
    var certificateCurrentValueSubject: CurrentValueSubject<Certificate?, Never> { get }
    var certificate: Certificate? { get }
    
    func observeCertificates()
    func getCertificate(with signature: String) async -> Certificate?
}

class CertificateProvider: CertificateProviderProtocol {
    var certificateCurrentValueSubject = CurrentValueSubject<Certificate?, Never>(nil)
    var certificate: Certificate? {
        certificateCurrentValueSubject.value
    }
    private let signature: String
    private let certificatesRepo: CertificatesRepoProvider
    private var cancallable = Set<AnyCancellable>()
    
    init(
        certificatesRepo: CertificatesRepoProvider,
        signature: String
    ) {
        self.certificatesRepo = certificatesRepo
        self.signature = signature
    }
    
    func getCertificate(with signature: String) async -> Certificate? {
        await certificatesRepo.reloadRepoAsync()
        let certificate = certificatesRepo.certificates?.first(where: { certificate in
            certificate.signature == signature
        })
        return certificate
    }
    
    func observeCertificates() {
        certificatesRepo.certificatesCurrentValueSubject.sink { [weak self] certificates in
            let certificate = self?.getCertificateBySignature(certificates)
            self?.certificateCurrentValueSubject.send(certificate)
        }.store(in: &cancallable)
    }
}

private extension CertificateProvider {
    func getCertificateBySignature(_ certificates: [Certificate]?) -> Certificate? {
        let certificate = certificates?.first(where: { certificate in
            certificate.signature == signature
        })
        return certificate
    }
}
