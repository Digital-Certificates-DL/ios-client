//
//  HomeScreenCoordinator.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/9/23.
//

import UIKit

class HomeScreenCoordinator: Coordinator {
    
    enum Path {
        case uploadImage
        case useCamera
        case dismiss
    }
    
    weak var previousCoordinator: Coordinator?
    var currentCoordinator: Coordinator?
    var rootNavigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let model = HomeScreenModel()
        let viewModel = HomeScreenViewModel(model: model) { [weak self] path in
            switch path {
            case .useCamera:
                self?.startUseCameraFlow()
            case .uploadImage:
                self?.startUploadImageFlow()
            case .dismiss:
                self?.dismiss()
            }
        }
        let viewController = HomeScreenViewController(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeScreenCoordinator {
    func startUseCameraFlow() {
        // TODO
    }
    
    func startUploadImageFlow() {
        // TODO
    }
    
    func dismiss() {
        previousCoordinator?.currentCoordinator = nil
    }
}
