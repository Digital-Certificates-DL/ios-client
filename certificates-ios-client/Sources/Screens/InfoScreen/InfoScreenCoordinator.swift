//
//  InfoScreenCooedinator.swift
//  certificates-ios-client
//
//  Created by Apik on 12.05.2023.
//

import UIKit



class InfoScreenCoordinator: Coordinator {
    
    enum Path {
        case dismiss
    }
    
    deinit {
        print("deinitedddd")
    }
    
    weak var previousCoordinator: Coordinator?
    var currentCoordinator: Coordinator?
    var rootNavigationController: NavigationController
    private let validatedCertificate: QrDataValidated
    
    init(
        rootNavigationController: NavigationController,
        validatedCertificate: QrDataValidated
    ) {
        self.rootNavigationController = rootNavigationController
        self.validatedCertificate = validatedCertificate
    }
    
    func start() {
        let model = InfoScreenModel(validatedCertificate: validatedCertificate)
        let viewModel = InfoScreenViewModel(model: model) { path in
            switch path {
            case .dismiss:
                self.dismiss()
            }
        }
        let viewController = InfoScreenViewController(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}

extension InfoScreenCoordinator {
    func dismiss() {
        rootNavigationController.popToRootViewController(animated: true)
        let homeCoordinator = FindCoordinatorManager.shared.findCoordinatorReverse(self, findCoordinatorType: HomeScreenCoordinator.self)
        homeCoordinator?.currentCoordinator = nil
    }
}
