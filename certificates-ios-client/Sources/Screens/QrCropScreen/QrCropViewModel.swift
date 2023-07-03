//
//  QrCropViewModel.swift
//  certificates-ios-client
//
//  Created by Apik on 17.05.2023.
//

import Foundation
import Combine

protocol QrCropViewModelProvider: AnyObject {
    var startLoader: CurrentValueSubject<Bool, Never> { get }
    
    func sendQrData(_ qrStringData: String) 
    func dismiss()
}

class QrCropViewModel: QrCropViewModelProvider {
    enum Path {
        case dismiss
        case startSmthWentWrongFlow
        case startInfoFlow(QrDataValidated)
    }
    
    private(set) var startLoader: CurrentValueSubject<Bool, Never> = .init(false)
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
        startLoader.send(true)
        guard let qrData = certificateVerifier.parseQrCode(qrStringData),
              certificateVerifier.isValidQrCode(qrData) else {
            startLoader.send(false)
            startSmthWentWrong()
            return
        }
        
        startLoader.send(true)
        Task { [unowned self] in
            let validatedCertificate = await self.certificateVerifier.validateCertificate(qrData)
            await MainActor.run {
                self.startInfoScreen(validatedCertificate: validatedCertificate)
                self.startLoader.send(false)
            }
        }
    }
    
    func dismiss() {
        
    }
    
    private func startInfoScreen(validatedCertificate: QrDataValidated) {
        pathHandler(.startInfoFlow(validatedCertificate))
    }

    private func startSmthWentWrong() {
        pathHandler(.startSmthWentWrongFlow)
    }
}
