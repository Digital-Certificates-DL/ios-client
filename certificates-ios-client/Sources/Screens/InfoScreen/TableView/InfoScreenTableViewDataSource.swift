//
//  InfoScreenTableViewDataSource.swift
//  certificates-ios-client
//
//  Created by Apik on 11.05.2023.
//

import UIKit

enum InfoScreenTableViewDataSource {
    typealias Source = UITableViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Hashable {
        case main
    }
    
    enum Item: Hashable {
        case itemTitle (title: String, content: String)
        case itemButton (title: String, icon: UIImage)
        case itemTime (time: String)
        case itemStatus(isConfirmed: Bool)
    }
    
    
}
