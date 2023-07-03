//
//  QrCropCoordinator.swift
//  certificates-ios-client
//
//  Created by Apik on 17.05.2023.
//

import UIKit
import Mantis
class QrCropCoordinator: Coordinator {
    var previousCoordinator: Coordinator?
    var currentCoordinator: Coordinator?
    
    private let rootNavigationController: NavigationController
    private let selectrdImage: UIImage
    private let serviceManager = ServiceManager.shared
    
    init(rootNavigationController: NavigationController, image: UIImage) {
        self.rootNavigationController = rootNavigationController
        selectrdImage = image
    }
    
    func start() {
        let model = QrCropModel()
        
        let certificateProvider = CertificateProvider(
            certificatesRepo: serviceManager.reposManager.certificatesRepo,
            signature: ""
        )
        
        let transactionProvider = TransactionProvider(
            transactionApi: serviceManager.apiManager.transactionsAPI
        )
        
        let certificateVerifier = CertificateVerifier(
            certificateProvider: certificateProvider,
            transactionProvider: transactionProvider
        )
        
        let viewModel = QrCropViewModel(model: model, certificateVerifier: certificateVerifier) { path in
            switch path {
                case .dismiss:
                    self.dismiss()
                case .startSmthWentWrongFlow:
                    self.startSmthWentWrongFlow()
                case .startInfoFlow(let validatedQr):
                    self.startInfoFlow(validatedCertificate: validatedQr)
            }
        }
        let cropViewController: QrCropViewController = Mantis.cropViewController(image: selectrdImage, config: QrCropViewController.getConfig())
        cropViewController.viewModel = viewModel
        rootNavigationController.pushViewController(cropViewController, animated: true)
    }
        
    func startSmthWentWrongFlow() {
        let coordinator = SmthWentWrongScreenCoordinator(rootNavigationController: self.rootNavigationController)
        coordinator.previousCoordinator = self
        self.currentCoordinator = coordinator
        coordinator.start()
    }
    
    func startInfoFlow(validatedCertificate: QrDataValidated) {
        let coordinator = InfoScreenCoordinator(rootNavigationController: rootNavigationController, validatedCertificate: validatedCertificate)
        coordinator.previousCoordinator = self
        self.currentCoordinator = coordinator
        coordinator.start()
    }
    
    func dismiss() {
        
    }
}
