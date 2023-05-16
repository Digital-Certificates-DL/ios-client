//
//  InfoButtonTableViewCell.swift
//  certificates-ios-client
//
//  Created by Apik on 12.05.2023.
//

import UIKit
import SnapKit

class InfoButtonTableViewCell: UITableViewCell {
    lazy private var infoButtonLabel: UILabel = {
        let label = UILabel()
        label.font = .p16InterMedium
        label.textColor = .black
        return label
    }()
    lazy private var infoButtonIcon: UIImageView = {
        let imageView = UIImageView()
        backgroundColor = .blue
        imageView.tintColor = .accentPrimary
        return imageView
    }()
    
    lazy private var separator: UIView = {
        let line = UIView()
        line.backgroundColor = .borderSecondary
        return line
    }()
    
    lazy private var currentView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: InfoButtonTableViewCell.identifier)
        setupSubviews()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        title: String,
        icon: UIImage
    ) {
        self.infoButtonIcon.image = icon
        self.infoButtonLabel.text = title
    }
    
    private func setupSubviews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(currentView)
        currentView.addSubview(infoButtonIcon)
        currentView.addSubview(infoButtonLabel)
        currentView.addSubview(separator)
    }
    
    private func setupAutoLayout() {
        
        currentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(56.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        infoButtonLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(infoButtonIcon.snp.right)
            make.centerY.equalToSuperview()
        }
        
        infoButtonIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.0)
            make.centerY.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(1.0)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
