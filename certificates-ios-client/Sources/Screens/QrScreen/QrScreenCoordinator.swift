//
//  QrScreenCoordinator.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/12/23.
//

import UIKit

class QrScreenCoordinator: Coordinator {
    var previousCoordinator: Coordinator?
    var currentCoordinator: Coordinator?
    
    weak var viewModel: QrScreenViewModelProvider?
    private let serviceManager: ServiceManagerProvider
    private let rootNavigationController: NavigationController
    
    init(rootNavigationController: NavigationController) {
        self.rootNavigationController = rootNavigationController
        self.serviceManager = ServiceManager.shared
    }
    
    func start() {
        let model = QrScreenModel()
        
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
        
        let viewModel = QrScreenViewModel(
            model: model,
            certificateVerifier: certificateVerifier
        ) { path in
            switch path {
            case .dismiss:
                self.dismiss()
            case .startSmthWentWrong:
                self.startSmthWentWrongFlow()
            case .startInfoFlow(let validatedQr):
                self.startInfoFlow(validatedCertificate: validatedQr)
            }
        }
        
        self.viewModel = viewModel
        let viewController = QrScreenViewController(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, from: .fromTop)
    }
    
    func startSmthWentWrongFlow() {
        let coordinator = SmthWentWrongScreenCoordinator(rootNavigationController: self.rootNavigationController) { [unowned self] externalPath in
            switch externalPath {
            case .tryAgain:
                self.viewModel?.setNeedToStartScaning(true)
            }
        }
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
        rootNavigationController.popViewController(from: .fromBottom)
    }
}
