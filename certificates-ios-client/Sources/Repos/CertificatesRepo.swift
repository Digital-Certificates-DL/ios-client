//
//  CertificateRepos.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 17.05.2023.
//

import Foundation
import Combine

protocol CertificatesRepoProvider {
    var certificatesCurrentValueSubject: CurrentValueSubject<[Certificate]?, Never> { get }
    var certificates: [Certificate]? { get }
    
    func reloadRepo()
    func reloadRepoAsync() async 
}

class CertificatesRepo: CertificatesRepoProvider {
    private let api: ApiClientProvider
    
    var certificatesCurrentValueSubject = CurrentValueSubject<[Certificate]?, Never>(nil)
    var certificates: [Certificate]? {
        certificatesCurrentValueSubject.value
    }
    
    init(apiManager: ApiClientProvider) {
        self.api = apiManager
        reloadRepo()
    }
    
    func reloadRepo() {
        Task { [weak self] in
            await self?.reloadRepoAsync()
        }
    }
    
    func reloadRepoAsync() async {
        guard let certificatesData = await api.certificatesApi.getCertificates(),
              let certificatesDictionary = convertCertificateDataToDictionary(certificatesData),
              let certificatesResult = parseCertificateData(certificatesDictionary) else {
            certificatesCurrentValueSubject.send(nil)
            return
        }
        certificatesCurrentValueSubject.send(certificatesResult)
    }
}

private extension CertificatesRepo {
    func parseCertificateData(
        _ certificatesDictionary: [String: [[String]]]
    ) -> [Certificate]? {
        var resultCertificates: [Certificate] = []
        guard var certificates = certificatesDictionary["result1"],
              certificates.count > 0 else { return nil }
        // returns only 1 array of arrays, and first array it's keys
        certificates.removeFirst()
        for certificate in certificates {
            resultCertificates.append(
                Certificate(
                    date: certificate[0],
                    participant: certificate[1],
                    courseTitle: certificate[2],
                    points: certificate[3],
                    note: certificate[4],
                    serialNumber: certificate[5],
                    certificate: certificate[6],
                    dataHash: certificate[7],
                    txHash: certificate[8],
                    signature: certificate[9],
                    digitalCertificate: certificate[10]
                )
            )
        }
        return resultCertificates
    }
    
    func convertCertificateDataToDictionary(
        _ certificateData: Data
    ) -> [String: [[String]]]? {
        guard let certificateDictionary = try? JSONSerialization.jsonObject(with: certificateData) as? [String: [[String]]] else { return nil }
        return certificateDictionary
    }
}
