//
//  HomeScreenViewModel.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/9/23.
//

import Foundation
import Combine
import UIKit

protocol HomeScreenViewModelProvider: AnyObject {
    var actionsPublisher: Published<[HomeScreenTableViewDataSource.Item]>.Publisher { get }
    
    func didLoad()
    func selectUseCameraAction()
    func selectUploadImageAction(image: UIImage)
    func dismiss()
}

class HomeScreenViewModel: HomeScreenViewModelProvider {
    var actionsPublisher: Published<[HomeScreenTableViewDataSource.Item]>.Publisher { $actions }
    @Published private var actions: [HomeScreenTableViewDataSource.Item] = []
    private let pathHandler: (HomeScreenCoordinator.Path) -> Void
    private let model: HomeScreenModelProvider
    
    init(
        model: HomeScreenModelProvider,
        pathHandler: @escaping (HomeScreenCoordinator.Path) -> Void
    ){
        self.model = model
        self.pathHandler = pathHandler
    }
    
    func didLoad() {
       actions = model.getAllActions()
    }
    
    func selectUseCameraAction() {
        pathHandler(.useCamera)
    }
    
    func selectUploadImageAction(image: UIImage) {
        pathHandler(.uploadImage(image: image))
    }
    
    func dismiss() {
        // now it isn't called
        pathHandler(.dismiss)
    }
}
