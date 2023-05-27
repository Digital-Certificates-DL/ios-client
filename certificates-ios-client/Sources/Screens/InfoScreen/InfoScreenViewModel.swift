//
//  InfoScreenViewModel.swift
//  certificates-ios-client
//
//  Created by Apik on 11.05.2023.
//

import UIKit

protocol InfoScreenViewModelProvider: AnyObject {
    var infoItemsPublisher: Published<[InfoScreenTableViewDataSource.Item]>.Publisher { get }
    func didLoad()
    func dismiss()
    
    func copyData()
    func shereData() -> String
}



class InfoScreenViewModel: InfoScreenViewModelProvider {
    var infoItemsPublisher: Published<[InfoScreenTableViewDataSource.Item]>.Publisher { $items }
    @Published private var items: [InfoScreenTableViewDataSource.Item] = []
    private let pathHandler: (HomeScreenCoordinator.Path) -> Void
    private let model: InfoScreenModelProvider
    
    init(
        model: InfoScreenModelProvider,
        pathHandler: @escaping (HomeScreenCoordinator.Path) -> Void
    ){
        self.model = model
        self.pathHandler = pathHandler
    }
    
    func copyData() {
        UIPasteboard.general.string = model.getDataForCopy()
    }
    
    func shereData() -> String {
        model.getDataForCopy()
    }
    
    func didLoad() {
        items = model.getAllInfoItems()
    }
    
    func dismiss() {
        // now it isn't called
        pathHandler(.dismiss)
    }
}
