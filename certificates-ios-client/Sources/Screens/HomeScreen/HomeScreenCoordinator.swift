//
//  HomeScreenCoordinator.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/9/23.
//

import UIKit

class HomeScreenCoordinator: Coordinator {
    
    enum Path {
        case uploadImage(image: UIImage)
        case useCamera
        case dismiss
    }
    
    weak var previousCoordinator: Coordinator?
    var currentCoordinator: Coordinator?
    var rootNavigationController: NavigationController
    
    init(rootNavigationController: NavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let model = HomeScreenModel()
        let viewModel = HomeScreenViewModel(model: model) { path in
            switch path {
            case .useCamera:
                self.startUseCameraFlow()
            case .uploadImage(let image):
                self.startUploadImageFlow(image: image)
            case .dismiss:
                self.dismiss()
            }
        }
        let viewController = HomeScreenViewController(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeScreenCoordinator {
    func startUseCameraFlow() {
        let coordinator = QrScreenCoordinator(rootNavigationController: rootNavigationController)
        coordinator.previousCoordinator = self
        currentCoordinator = coordinator
        coordinator.start()
    }
    
    func startUploadImageFlow(image: UIImage) {
        let coordinator = QrCropCoordinator(rootNavigationController: rootNavigationController, image: image)
        coordinator.previousCoordinator = self
        currentCoordinator = coordinator
        coordinator.start()
    }
    
    func dismiss() {
        previousCoordinator?.currentCoordinator = nil
    }
}
