//
//  ActionTableViewCell.swift
//  certificates-ios-client
//
//  Created by Apik on 11.05.2023.
//

import UIKit
import SnapKit

class InfoTitleTableViewCell: UITableViewCell {
    lazy private var infoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoBold
        label.textColor = .black
        return label
    }()
    lazy private var contentTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoRegular
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: InfoTitleTableViewCell.identifier)
        setupSubviews()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        title: String,
        content: String
    ) {
        self.contentTitleLabel.text = content
        self.infoTitleLabel.text = title
    }
    
    private func setupSubviews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(contentTitleLabel)
        contentView.addSubview(infoTitleLabel)
    }
    
    private func setupAutoLayout() {
        
    
        infoTitleLabel.snp.makeConstraints { make in
            
            make.top.equalToSuperview().inset(8.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        
        contentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(16.0)
        }
    }
    
}
