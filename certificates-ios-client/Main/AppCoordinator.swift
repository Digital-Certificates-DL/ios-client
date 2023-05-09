//
//  AppCoordinator.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/9/23.
//

import UIKit

enum StartPoints {
    case tabBarCoordinator
}

class AppCoordinator: Coordinator {
    weak var previousCoordinator: Coordinator? = nil
    var currentCoordinator: Coordinator?
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        startTabBarCoordinator()
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator {
    func startTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(window: window)
        tabBarCoordinator.previousCoordinator = self
        tabBarCoordinator.start()
    }
}
