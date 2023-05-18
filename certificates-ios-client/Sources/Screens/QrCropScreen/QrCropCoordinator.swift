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
    
    private let requiredKeys = ["message", "address", "signature"]
    private let rootNavigationController: UINavigationController
    private let selectrdImage: UIImage
    
    init(rootNavigationController: UINavigationController, image: UIImage) {
        self.rootNavigationController = rootNavigationController
        selectrdImage = image
    }
    
    func start() {
        let model = QrCropModel()
        let viewModel = QrCropViewModel(model: model) { path in
            switch path {
            case .parseQr(let qrStringData):
                self.parseQrStringData(qrStringData)
            case .dismiss:
                print("")
            }
        }
        let cropViewController: QrCropViewController = Mantis.cropViewController(image: selectrdImage, config: QrCropViewController.getConfig())
        cropViewController.viewModel = viewModel
        rootNavigationController.pushViewController(cropViewController, animated: true)
    }
}


private extension QrCropCoordinator {
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
