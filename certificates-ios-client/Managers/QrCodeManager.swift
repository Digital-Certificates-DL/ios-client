//
//  QrCodeManager.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 03.07.2023.
//

import AVFoundation
import UIKit

class QrCodeScanner: NSObject {
    
    lazy var captureSession = AVCaptureSession()
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    lazy var metadataOutput = AVCaptureMetadataOutput()
    let sessionQueue = DispatchQueue(label: "sessionQueue", qos: .background)
    lazy var delegate: AVCaptureMetadataOutputObjectsDelegate? = (self as AVCaptureMetadataOutputObjectsDelegate) {
        didSet {
            metadataOutput.setMetadataObjectsDelegate(
                self.delegate,
                queue: self.sessionQueue
            )
        }
    }
    
    init(
        viewController: UIViewController // must provide qr code delegate
    ) {
        super.init()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        guard captureSession.canAddInput(videoInput) else { return }
        captureSession.addInput(videoInput)
        guard captureSession.canAddOutput(metadataOutput) else { return }
        captureSession.addOutput(metadataOutput)
        metadataOutput.metadataObjectTypes = [.qr]
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.frame
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
    }
    
    func startScan() {
        if !captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopScan() {
        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }
}

extension QrCodeScanner: AVCaptureMetadataOutputObjectsDelegate {}
