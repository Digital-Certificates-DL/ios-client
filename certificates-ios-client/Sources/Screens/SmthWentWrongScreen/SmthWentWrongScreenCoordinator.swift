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
    
    var previousCoordinator: Coordinator?
    var currentCoordinator: Coordinator?
    
    private let rootNavigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let model = SmthWentWrongScreenModel()
        let viewModel = SmthWentWrongScreenViewModel(model: model) { path in
            switch path {
            case .tryAgain:
                self.tryAgain()
            case .dismiss:
                self.dismiss()
            }
        }
        let viewController = SmthWentWrongScreenViewController(viewModel: viewModel)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        rootNavigationController.present(viewController, animated: true)
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
