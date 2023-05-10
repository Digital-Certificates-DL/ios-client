//
//  ConfirmButton.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/10/23.
//

import UIKit

class ConfirmButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .accentPrimary
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
    }
    

}
