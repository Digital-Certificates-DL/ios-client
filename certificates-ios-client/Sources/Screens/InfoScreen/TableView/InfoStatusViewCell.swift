//
//  InfoStatusViewCell.swift
//  certificates-ios-client
//
//  Created by Apik on 15.05.2023.
//

import UIKit
import SnapKit


class InfoStatusViewCell: UITableViewCell {
    lazy private var iconStatus: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    lazy private var labelStatus: UILabel = {
        let label = UILabel()
        label.font = .p16InterMedium
        label.textColor = .black
        return label
    }()
    
    lazy private var currentView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: ActionTableViewCell.identifier)
        setupSubviews()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configure(
        isConfirmed: Bool
    ) {
        if(isConfirmed){
            self.iconStatus.image = .ic_confirmed
            self.labelStatus.text = "Confirmed"
            contentView.backgroundColor = .succesPrimary
        }else {
            self.iconStatus.image = .ic_desline
            self.labelStatus.text = "Not confirmed"
            contentView.backgroundColor = .errorPrimary
        }
    }
    
    private func setupSubviews() {
        
        contentView.addSubview(currentView)
        
        currentView.addSubview(iconStatus)
        currentView.addSubview(labelStatus)
    }
    
    private func setupAutoLayout() {
        
        currentView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(16.0)
            make.width.equalTo(142.0)
        }
        
        iconStatus.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.bottom.top.equalToSuperview()
            make.left.equalTo(currentView.snp.left)
        }
        
        labelStatus.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.bottom.top.equalToSuperview()
            make.left.equalTo(iconStatus.snp.right).offset(8.0)
        }
        
    }
}
