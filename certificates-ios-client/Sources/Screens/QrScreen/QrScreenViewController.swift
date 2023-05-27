//
//  QrScreenViewController.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/12/23.
//

import UIKit
import AVFoundation
import SnapKit
import Combine

class QrScreenViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var metadataOutput: AVCaptureMetadataOutput!
    let sessionQueue = DispatchQueue(label: "sessionQueue", qos: .background)

    private let viewModel: QrScreenViewModelProvider
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var scannerView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .red
        myView.layer.opacity = 0.5
        return myView
    }()
    
    private lazy var scaleSlider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .white
        slider.minimumValue = 1.0
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .white
        slider.addTarget(self, action: #selector(sliderDidChangeValue(slider:)), for: .valueChanged)
        return slider
    }()
    
    init(viewModel: QrScreenViewModelProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQrScanner()
        startScan()
        bind()
        setupAutoLayout()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetToDefaultAppearance()
        startScan()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScan()
    }

    
    func setupAutoLayout() {
        view.addSubview(scannerView)
        view.addSubview(scaleSlider)
        
        scannerView.snp.makeConstraints { make in
            make.size.equalTo(116.0)
            make.center.equalToSuperview()
        }
        
        scaleSlider.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-150.0)
            make.leading.trailing.equalToSuperview().inset(30.0)
        }
    }
    
    private func bind() {
        viewModel.needToStartScaning.sink { startScan in
            if startScan {
                self.startScan()
            }
        }.store(in: &cancellable)
    }
    
    private func resetToDefaultAppearance() {
        navigationController?.navigationBar.backItem?.title = nil
        navigationController?.navigationBar.tintColor = .accentPrimary
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func startScan() {
        if captureSession?.isRunning == false {
            sessionQueue.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    private func stopScan() {
        if captureSession?.isRunning == true {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    private func setupQrScanner() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        guard captureSession.canAddInput(videoInput) else { return }
        let videomMaxZoomFactor = videoCaptureDevice.activeFormat.videoMaxZoomFactor
        scaleSlider.maximumValue = Float(videomMaxZoomFactor)
        captureSession.addInput(videoInput)
        metadataOutput = AVCaptureMetadataOutput()
        guard captureSession.canAddOutput(metadataOutput) else { return }
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    @objc private func sliderDidChangeValue(slider: UISlider) {
        guard let input = captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        try? input.device.lockForConfiguration()
        input.device.videoZoomFactor = CGFloat(slider.value)
        input.device.unlockForConfiguration()
    }
}

extension QrScreenViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let metadataObjectRect = previewLayer.transformedMetadataObject(for: metadataObject) else { return }
            if scannerView.frame.contains(metadataObjectRect.bounds) {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                viewModel.sendQrData(stringValue)
                stopScan()
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}


