//
//  QrCropViewModel.swift
//  certificates-ios-client
//
//  Created by Apik on 17.05.2023.
//

import Foundation


protocol QrCropViewModelProvider: AnyObject {
    func sendQrData(_ qrStringData: String) 
    func dismiss()
}

class QrCropViewModel: QrCropViewModelProvider {
    enum Path {
        case dismiss
        case presentLoader
        case dismissLoaderAndStartSmthWentWrongFlow
        case dismissLoaderAndStartInfoFlow(QrDataValidated)
    }
    
    private let certificateVerifier: CertificateVerifierProtocol
    private let pathHandler: (QrCropViewModel.Path) -> Void
    private let model: QrCropModelProvider
    
    init(
        model: QrCropModelProvider,
        certificateVerifier: CertificateVerifierProtocol,
        pathHandler: @escaping (QrCropViewModel.Path) -> Void
    ) {
        self.model = model
        self.certificateVerifier = certificateVerifier
        self.pathHandler = pathHandler
    }
    
    func sendQrData(_ qrStringData: String) {
        startLoader()
        guard let qrData = certificateVerifier.parseQrCode(qrStringData),
              certificateVerifier.isValidQrCode(qrData) else {
            startSmthWentWrong()
            return
        }
        
        Task { [unowned self] in
            let validatedCertificate = await self.certificateVerifier.validateCertificate(qrData)
            await MainActor.run {
                self.startInfoScreen(validatedCertificate: validatedCertificate)
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
