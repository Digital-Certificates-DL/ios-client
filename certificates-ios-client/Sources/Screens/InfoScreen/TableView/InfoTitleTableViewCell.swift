//
//  ActionTableViewCell.swift
//  certificates-ios-client
//
//  Created by Apik on 11.05.2023.
//

import UIKit
import SnapKit

class InfoTitleTableViewCell: UITableViewCell {
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
    
}
