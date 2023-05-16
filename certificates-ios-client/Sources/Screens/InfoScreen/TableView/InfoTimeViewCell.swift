//
//  InfoTimeViewCell.swift
//  certificates-ios-client
//
//  Created by Apik on 15.05.2023.
//
import UIKit
import SnapKit


class InfoTimeViewCell: UITableViewCell {
    
    lazy private var timeLable: UILabel = {
        var label = UILabel()
        label.textColor = .textSecondary
        label.font = .p16InterRegular
        return label
    }()
    
    lazy private var currentView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackground
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
        time: String
    ) {
        self.timeLable.text = time
    }
    
    
    private func setupSubviews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(currentView)
        currentView.addSubview(timeLable)
    }
    
    private func setupAutoLayout() {
        
        currentView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(56.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        timeLable.snp.makeConstraints { make in
            
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
        }
        
    }
    
    
}
