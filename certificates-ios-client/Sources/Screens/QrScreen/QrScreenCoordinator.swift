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
    
    private let requiredKeys = ["message", "address", "signature"]
    private let rootNavigationController: UINavigationController
    
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        let model = QrScreenModel()
        let viewModel = QrScreenViewModel(model: model) { path in
            switch path {
            case .dismiss:
                self.dismiss()
            case .parseQr(let qrStringData):
                self.parseQrStringData(qrStringData)
            }
        }
        let viewController = QrScreenViewController(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}

private extension QrScreenCoordinator {
        
    func dismiss() {
        
    }
    
    func parseQrStringData(_ data: String) {
        presentLoaderScreenViewController()
        if isQrKeyValueValid(data) {
            let keyValue = getDictionaryFromString(data)
            let qrData = QrData(
                message: keyValue["message"] ?? "",
                address: keyValue["address"] ?? "",
                signature: keyValue["signature"] ?? "",
                certificatePage: keyValue["certificate page"]
            )
            
        } else {
            rootNavigationController.dismiss(animated: true) {
                let coordinator = SmthWentWrongScreenCoordinator(rootNavigationController: self.rootNavigationController)
                coordinator.previousCoordinator = self
                self.currentCoordinator = coordinator
                coordinator.start()
            }
        }
    }
    
    func presentLoaderScreenViewController() {
        let loaderViewController = LoaderScreenViewController()
        loaderViewController.modalTransitionStyle = .crossDissolve
        loaderViewController.modalPresentationStyle = .overFullScreen
        rootNavigationController.present(loaderViewController, animated: true)
    }
    
    func isQrKeyValueValid(_ dictionary: [String: String]) -> Bool {
        var containsAllRequiredKeys = true
        requiredKeys.forEach { requiredKey in
            if !dictionary.keys.contains(requiredKey) {
                containsAllRequiredKeys = false
            }
        }
        return containsAllRequiredKeys && dictionary.keys.count == 4
    }
    
    func isQrKeyValueValid(_ qrString: String) -> Bool {
        var containsAllRequiredKeys = true
        requiredKeys.forEach { requiredKey in
            if !qrString.contains(requiredKey) {
                containsAllRequiredKeys = false
            }
        }
        return containsAllRequiredKeys
    }
    
    func getDictionaryFromString(_ qrString: String) -> [String: String] {
        var keyValueDictionary: [String: String] = [:]
        let formattedString = deleteNewLineAfterKey(qrString)
        let keyValues = formattedString.split(separator: "\n")
        for keyValue in keyValues {
            let key = String(keyValue.split(separator: ":", maxSplits: 1)[0])
            let value = String(keyValue.split(separator: ":", maxSplits: 1)[1])
            keyValueDictionary[key] = value
        }
        return keyValueDictionary
    }
    
    func deleteNewLineAfterKey(_ qrString: String) -> String {
        var findColon = false
        var resultString = ""
        var findedTimes = 0
        for character in qrString {
            if findColon {
                resultString.append("")
                findColon = false
                findedTimes = 0
                continue
            }
            if character == ":" && findedTimes == 0 {
                findColon = true
                findedTimes += 1
            }
            resultString.append(character)
        }
        return resultString
    }
    
}


