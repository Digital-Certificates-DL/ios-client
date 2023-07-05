//
//  QrCropViewController.swift
//  certificates-ios-client
//
//  Created by Apik on 17.05.2023.
//

import UIKit
import Mantis
import Combine

class QrCropViewController: CropViewController {
    var viewModel: QrCropViewModelProvider? = nil
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        bind()
        title = nil
        delegate = self
    }
    
    public static func getConfig() -> Mantis.Config {
        var config = Mantis.Config()
        config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1.0)
        config.cropViewConfig.showRotationDial = false
        return config
    }
    
    private func bind() {
        viewModel!.startLoader.sink { startLoader in
            if startLoader {
                self.presentLoader()
            } else {
                self.dismissLoader()
            }
        }.store(in: &cancellable)
    }
        
    private func presentLoader() {
        let viewController = LoaderScreenViewController()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
    
    private func dismissLoader() {
        self.dismiss(animated: true)
    }
    
    private func parseQr(from image: UIImage) -> String? {
        var qrAsString = ""
        guard let detector = CIDetector(
            ofType: CIDetectorTypeQRCode,
            context: nil,
            options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
              let ciImage = CIImage(image: image),
              let features = detector.features(in: ciImage) as? [CIQRCodeFeature] else {
            return nil
        }
        
        for feature in features {
            guard let indeedMessageString = feature.messageString else {
                continue
            }
            qrAsString += indeedMessageString
        }
        
        return qrAsString
    }
    
    @objc private func onRotateClicked() {
        didSelectClockwiseRotate()
    }

    @objc private func onDoneClicked() {
        crop()
    }
}

extension QrCropViewController : CropViewControllerDelegate{
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
        let rawData = parseQr(from: cropped)
        if rawData != nil {
            viewModel!.sendQrData(rawData!)
        }
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true, completion: nil)
        viewModel!.dismiss()
    }
}
