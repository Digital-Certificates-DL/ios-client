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
    
    weak var previousCoordinator: Coordinator?
    var currentCoordinator: Coordinator?
    var rootNavigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let model = InfoScreenModel()
        let viewModel = InfoScreenViewModel(model: model) { [weak self] path in
            
        }
        let viewController = InfoScreenViewController(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}

extension InfoScreenCoordinator {
   
    func dismiss() {
        previousCoordinator?.currentCoordinator = nil
    }
}
