//
//  QrScreenViewModel .swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/12/23.
//

import Foundation


protocol QrScreenViewModelProvider: AnyObject {
    func sendQrData(_ qrStringData: String)
    func dismiss()
}

class QrScreenViewModel: QrScreenViewModelProvider {
    typealias Action = () -> Void
    
    enum Path {
        case dismiss
        case presentLoader
        case dismissLoaderAndStartSmthWentWrongFlow
        case dismissLoaderAndStartInfoFlow
    }
    
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
                startInfoScreen()
            }
        }
    }
    
    func dismiss() {
        
    }
    
    private func startInfoScreen() {
        pathHandler(.dismissLoaderAndStartInfoFlow)
    }
        
    private func startLoader() {
        pathHandler(.presentLoader)
    }
    
    private func startSmthWentWrong() {
        pathHandler(.dismissLoaderAndStartSmthWentWrongFlow)
    }

}
