//
//  QrScreenViewModel .swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/12/23.
//

import Foundation
import Combine


protocol QrScreenViewModelProvider: AnyObject {
    var needToStartScaning: CurrentValueSubject<Bool, Never> { get }

    func setNeedToStartScaning(_ bool: Bool)
    func sendQrData(_ qrStringData: String)
    func dismiss()
}

class QrScreenViewModel: QrScreenViewModelProvider {
    typealias Action = () -> Void
    
    enum Path {
        case dismiss
        case presentLoader
        case dismissLoaderAndStartSmthWentWrongFlow
        case dismissLoaderAndStartInfoFlow(QrDataValidated)
    }
    
    private(set) var needToStartScaning: CurrentValueSubject<Bool, Never> = .init(false)
    
    private let pathHandler: (QrScreenViewModel.Path) -> Void
    private let model: QrScreenModelProvider
    private let certificateVerifier: CertificateVerifierProtocol
    
    init(
        model: QrScreenModelProvider,
        certificateVerifier: CertificateVerifierProtocol,
        pathHandler: @escaping (QrScreenViewModel.Path) -> Void
    ) {
        self.model = model
        self.pathHandler = pathHandler
        self.certificateVerifier = certificateVerifier
    }
    
    func setNeedToStartScaning(_ bool: Bool) {
        needToStartScaning.send(true)
    }
    
    func sendQrData(_ qrStringData: String) {
        startLoader()
        guard let qrData = certificateVerifier.parseQrCode(qrStringData),
              certificateVerifier.isValidQrCode(qrData) else {
            startSmthWentWrong()
            return
        }
        
        Task { [weak self] in
            let validatedCertificate = await self?.certificateVerifier.validateCertificate(qrData)
            await MainActor.run {
                startInfoScreen(validatedCertificate: validatedCertificate!)
            }
        }
    }
    
    func dismiss() {
        
    }
    
    private func startInfoScreen(validatedCertificate: QrDataValidated) {
        pathHandler(.dismissLoaderAndStartInfoFlow(validatedCertificate))
    }
        
    private func startLoader() {
        pathHandler(.presentLoader)
    }
    
    private func startSmthWentWrong() {
        pathHandler(.dismissLoaderAndStartSmthWentWrongFlow)
    }

}

