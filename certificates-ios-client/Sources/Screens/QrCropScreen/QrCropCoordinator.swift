//
//  QrCropCoordinator.swift
//  certificates-ios-client
//
//  Created by Apik on 17.05.2023.
//

import UIKit

class QrCropCoordinator: Coordinator {
    var previousCoordinator: Coordinator?
    var currentCoordinator: Coordinator?
    
    private let requiredKeys = ["message", "address", "signature"]
    private let rootNavigationController: UINavigationController
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let model = QrCropModel()
        let viewModel = QrCropViewModel(model: model) { path in
//            switch path {
//            case .dismiss:
//                self.dismiss()
//            case .parseQr(let qrStringData):
//                self.parseQrStringData(qrStringData)
//            }
        }
        let viewController = QrCropViewController(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}
