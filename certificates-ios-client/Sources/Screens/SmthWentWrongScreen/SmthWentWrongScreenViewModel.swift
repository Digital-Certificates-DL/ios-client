//
//  SmthWentWrongScreenViewModel.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 15.05.2023.
//

import Foundation


protocol SmthWentWrongScreenViewModelProvider: AnyObject {
    func tryAgain()
    func dismiss()
}

class SmthWentWrongScreenViewModel: SmthWentWrongScreenViewModelProvider {
    private let pathHandler: ((SmthWentWrongScreenCoordinator.Path) -> Void)
    private let model: SmthWentWrongScreenModelProvider
    
    init(model: SmthWentWrongScreenModel, pathHandler: @escaping (SmthWentWrongScreenCoordinator.Path) -> Void) {
        self.model = model
        self.pathHandler = pathHandler
    }
    
    func tryAgain() {
        pathHandler(.tryAgain)
    }
    
    func dismiss() {
        pathHandler(.dismiss)
    }
}
