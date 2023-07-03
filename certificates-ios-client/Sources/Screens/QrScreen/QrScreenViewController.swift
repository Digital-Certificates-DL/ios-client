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
    private let viewModel: QrScreenViewModelProvider
    private var cancellable = Set<AnyCancellable>()

    private lazy var qrCodeScanner = QrCodeScanner(viewController: self)
    
    private lazy var leftDarkView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .black
        myView.layer.opacity = 0.6
        return myView
    }()
    
    private lazy var topDarkView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .black
        myView.layer.opacity = 0.6
        return myView
    }()
    
    private lazy var bottomDarkView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .black
        myView.layer.opacity = 0.6
        return myView
    }()
    
    private lazy var rightDarkView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .black
        myView.layer.opacity = 0.6
        return myView
    }()
    
    private lazy var scannerView: UIImageView = {
        let imageVIew = UIImageView()
        
        return imageVIew
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.accentPrimary, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
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
        setupQrCodeScanner()
        setupSlider()
        setupNavigationBar()
        bind()
        setupAutoLayout()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetToDefaultAppearance()
        startScan()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScan()
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = .init(customView: backButton)
    }
    
    func setupQrCodeScanner() {
        qrCodeScanner.delegate = self
    }
    
    func setupAutoLayout() {
        view.addSubview(scannerView)
        view.addSubview(leftDarkView)
        view.addSubview(topDarkView)
        view.addSubview(bottomDarkView)
        view.addSubview(rightDarkView)
        view.addSubview(scaleSlider)
        
        scannerView.snp.makeConstraints { make in
            make.size.equalTo(200.0)
            make.center.equalToSuperview()
        }
        
        leftDarkView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(scannerView.snp.leading)
        }
        
        rightDarkView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(scannerView.snp.trailing)
        }
        
        topDarkView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(leftDarkView.snp.trailing)
            make.trailing.equalTo(rightDarkView.snp.leading)
            make.bottom.equalTo(scannerView.snp.top)
        }
        
        bottomDarkView.snp.makeConstraints { make in
            make.top.equalTo(scannerView.snp.bottom)
            make.leading.equalTo(leftDarkView.snp.trailing)
            make.trailing.equalTo(rightDarkView.snp.leading)
            make.bottom.equalToSuperview()
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
        
        viewModel.startLoader.sink { start in
            if start {
                self.presentLoader()
            } else {
                self.dismissLoader()
            }
        }.store(in: &cancellable)
    }
    
    private func resetToDefaultAppearance() {
        navigationController?.navigationBar.backItem?.title = nil
        navigationController?.navigationBar.tintColor = .accentPrimary
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func startScan() {
        qrCodeScanner.startScan()
    }
    
    private func stopScan() {
        qrCodeScanner.stopScan()
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
    
    @objc private func backButtonTapped() {
        viewModel.dismiss()
    }
    
    private func setupSlider() {
        scaleSlider.maximumValue = 5.0
    }

    
    @objc private func sliderDidChangeValue(slider: UISlider) {
        guard let input = qrCodeScanner.captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        try? input.device.lockForConfiguration()
        input.device.videoZoomFactor = CGFloat(slider.value)
        input.device.unlockForConfiguration()
    }
}

extension QrScreenViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            if let metadataObject = metadataObjects.first {
                guard let metadataObjectRect = self.qrCodeScanner.previewLayer.transformedMetadataObject(for: metadataObject) else { return }
                if self.scannerView.frame.contains(metadataObjectRect.bounds) {
                    guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                    guard let stringValue = readableObject.stringValue else { return }
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.stopScan()
                    self.viewModel.sendQrData(stringValue)
                }
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
