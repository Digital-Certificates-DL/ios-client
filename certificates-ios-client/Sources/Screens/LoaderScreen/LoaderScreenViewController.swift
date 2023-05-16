//
//  LoaderScreenViewController.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 15.05.2023.
//

import UIKit
import Lottie
import SnapKit

class LoaderScreenViewController: UIViewController {
    lazy var lottieAnimationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "loading_animation")
        animation.loopMode = .loop
        return animation
    }()
    
    lazy var waitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Wait a moment"
        label.font = .ginoraBold?.withSize(24.0)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lottieAnimationView.play()
    }
    
    func setupSubviews() {
        view.backgroundColor = .white
    }
    
    func setupAutoLayout() {
        view.addSubview(lottieAnimationView)
        view.addSubview(waitLabel)
        
        lottieAnimationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-32.0)
            make.size.equalTo(312.0)
        }
        
        waitLabel.snp.makeConstraints { make in
            make.top.equalTo(lottieAnimationView.snp.bottom).offset(-72.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
    }
}
