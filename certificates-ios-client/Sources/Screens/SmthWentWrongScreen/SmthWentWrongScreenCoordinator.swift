//
//  SmthWentWrongScreenCoordinator.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 15.05.2023.
//

import UIKit

class SmthWentWrongScreenCoordinator: Coordinator {
    
    enum Path {
        case tryAgain
        case dismiss
    }
    
    enum ExternalPath {
        case tryAgain
    }
    
    var previousCoordinator: Coordinator?
    var currentCoordinator: Coordinator?
    
    private let rootNavigationController: NavigationController
    private var externalPath: ((ExternalPath) -> Void)?
    
    init(rootNavigationController: NavigationController, _ externalPath: ((ExternalPath) -> Void)? = nil) {
        self.rootNavigationController = rootNavigationController
        self.externalPath = externalPath
    }
    
    func start() {
        let model = SmthWentWrongScreenModel()
        let viewModel = SmthWentWrongScreenViewModel(model: model) { path in
            switch path {
            case .tryAgain:
                self.tryAgain()
                self.externalPath?(.tryAgain)
            case .dismiss:
                self.dismiss()
            }
        }
        let viewController = SmthWentWrongScreenViewController(viewModel: viewModel)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        rootNavigationController.dismiss(animated: true) {
            self.rootNavigationController.present(viewController, animated: true)
        }
    }
    
}

extension SmthWentWrongScreenCoordinator {
    func tryAgain() {
        rootNavigationController.dismiss(animated: true)
        previousCoordinator?.currentCoordinator = nil
    }
    
    func dismiss() {
        previousCoordinator?.previousCoordinator?.currentCoordinator = nil
        rootNavigationController.popToRootViewController(animated: true)
        rootNavigationController.dismiss(animated: true)
    }
}
