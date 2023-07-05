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
    var startLoader: CurrentValueSubject<Bool, Never> { get }
    
    
    func setNeedToStartScaning(_ bool: Bool)
    func sendQrData(_ qrStringData: String)
    func dismiss()
}

class QrScreenViewModel: QrScreenViewModelProvider {
    typealias Action = () -> Void
    
    enum Path {
        case dismiss
        case startSmthWentWrong
        case startInfoFlow(QrDataValidated)
    }
    
    private(set) var needToStartScaning: CurrentValueSubject<Bool, Never> = .init(false)
    private(set) var startLoader: CurrentValueSubject<Bool, Never> = .init(false)
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
        pathHandler(.dismiss)
    }
    
    private func startInfoScreen(validatedCertificate: QrDataValidated) {
        pathHandler(.startInfoFlow(validatedCertificate))
    }
    
    private func startSmthWentWrong() {
        pathHandler(.startSmthWentWrong)
    }
}

