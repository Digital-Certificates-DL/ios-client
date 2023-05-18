//
//  QrCropViewController.swift
//  certificates-ios-client
//
//  Created by Apik on 17.05.2023.
//

import UIKit

class QrCropViewController: UIViewController {
    private lazy var selectedImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var cropButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let viewModel: QrCropViewModelProvider
    
    
    init(viewModel: QrCropViewModelProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAutoLayout()
    }
    
    func setupAutoLayout() {
        view.addSubview(selectedImage)
        
//        scannerView.snp.makeConstraints { make in
//            make.size.equalTo(116.0)
//            make.center.equalToSuperview()
//        }
//        
//        scaleSlider.snp.makeConstraints { make in
//            make.bottom.equalToSuperview().offset(-150.0)
//            make.leading.trailing.equalToSuperview().inset(30.0)
//        }
    }
}
