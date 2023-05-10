//
//  DataSource.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/10/23.
//

import UIKit


enum HomeScreenTableViewDataSource {
    typealias Source = UITableViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Hashable {
        case main
    }
    
    struct Item: Hashable {
        let image: UIImage
        let title: String
    }
}
