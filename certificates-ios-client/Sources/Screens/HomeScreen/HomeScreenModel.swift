//
//  HomeScreenModel.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/9/23.
//

import UIKit

protocol HomeScreenModelProvider: AnyObject {
    func getAllActions() -> [HomeScreenTableViewDataSource.Item]
}

class HomeScreenModel: HomeScreenModelProvider {
    private typealias Action = HomeScreenTableViewDataSource.Item
    func getAllActions() -> [HomeScreenTableViewDataSource.Item] {
        let usingCameraAction: Action = Action(
            image: .camera,
            title: "Using the camera"
        )
        let uploadImageAction: Action = Action(
            image: .gallery,
            title: "Upload image"
        )
        return [usingCameraAction, uploadImageAction]
    }
}
