//
//  ActionTableViewCell.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/10/23.
//

import UIKit
import SnapKit

class ActionTableViewCell: UITableViewCell {
        
    lazy private var actionImageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy private var actionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .ginoraBold?.withSize(20.0)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    lazy private var currentView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackground
        view.layer.cornerRadius = 12.0
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
        image: UIImage,
        title: String
    ) {
        self.actionImageImageView.image = image
        self.actionTitleLabel.text = title
    }
    
    private func setupSubviews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(currentView)
        currentView.addSubview(actionImageImageView)
        currentView.addSubview(actionTitleLabel)
    }
    
    private func setupAutoLayout() {
        
        currentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.height.equalTo(132.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        actionImageImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.centerX.equalToSuperview()
        }
        
        actionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(actionImageImageView.snp.bottom).offset(15.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
    }
}
