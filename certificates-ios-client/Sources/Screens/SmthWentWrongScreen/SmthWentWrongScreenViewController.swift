//
//  SmthWentWrongScreenViewController.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 15.05.2023.
//

import UIKit
import SnapKit
import secp256k1

class SmthWentWrongScreenViewController: UIViewController {

    private let viewModel: SmthWentWrongScreenViewModelProvider
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var scannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightRed
        imageView.image = .qrScanner
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 18
        return imageView
    }()
    
    lazy var smthWentWrongLabel: UILabel = {
        let label = UILabel()
        label.font = .ginoraBold?.withSize(24.0)
        label.textColor = .black
        label.text = "Something went wrong"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var smthWentWrongDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .p16InterRegular
        label.text = "Unfortunately the application could not scan the QR-code. Make sure your code is correct and try again."
        label.numberOfLines = 0
        return label
    }()
    
    lazy var backHomeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back home", for: .normal)
        button.titleLabel?.font = .p16InterMedium
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(backHomeButtonTouchUpInside), for: .touchUpInside)
        return button
    }()
    
    lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try again", for: .normal)
        button.titleLabel?.font = .p16InterMedium
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .accentPrimary
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(tryAgainButtonTouchUpInside), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: SmthWentWrongScreenViewModelProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupAutoLayout()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private func setupAutoLayout() {
        view.addSubview(contentView)
        contentView.addSubview(scannerImageView)
        contentView.addSubview(smthWentWrongLabel)
        contentView.addSubview(smthWentWrongDescriptionLabel)
        contentView.addSubview(tryAgainButton)
        contentView.addSubview(backHomeButton)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        scannerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40.0)
            make.centerX.equalToSuperview()
        }
                
        smthWentWrongLabel.snp.makeConstraints { make in
            make.top.equalTo(scannerImageView.snp.bottom).offset(36.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        smthWentWrongDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(smthWentWrongLabel.snp.bottom).offset(12.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        tryAgainButton.snp.makeConstraints { make in
            make.width.equalTo(112.0)
            make.height.equalTo(40.0)
            make.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(smthWentWrongDescriptionLabel.snp.bottom).offset(64.0).priority(999)
            make.top.greaterThanOrEqualTo(smthWentWrongDescriptionLabel).offset(24.0)
            make.bottom.equalToSuperview().inset(16.0)
        }
        
        backHomeButton.snp.makeConstraints { make in
            make.width.equalTo(112.0)
            make.height.equalTo(40.0)
            make.trailing.equalTo(tryAgainButton.snp.leading).offset(-16.0)
            make.bottom.equalToSuperview().inset(16.0)
            make.leading.greaterThanOrEqualToSuperview().offset(16.0)
        }
    }
    
    @objc private func backHomeButtonTouchUpInside() {
        viewModel.dismiss()
    }
    
    @objc private func tryAgainButtonTouchUpInside() {
        viewModel.tryAgain()
    }
}
