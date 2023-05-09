//
//  TabBarCoordinator.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/9/23.
//

import UIKit

class TabBarCoordinator: Coordinator {
    weak var previousCoordinator: Coordinator?
    var currentCoordinator: Coordinator?
    
    var window: UIWindow
    var viewControllers: [UIViewController] = []
    var coordinators: [Coordinator] = []
    
    lazy var tabBarViewController: UIViewController = {
        let tabBarViewController = BaseTabBarController()
        configureHomeCoordinator()
        coordinators.forEach {
            $0.previousCoordinator = self
            $0.start()
        }
        guard viewControllers.count > 0 else {
            fatalError("Setup tabBar viewControllers")
        }
        tabBarViewController.setViewControllers(viewControllers, animated: true)
        tabBarViewController.completion = { [weak self] itemIndex in
            self?.currentCoordinator = self?.coordinators[itemIndex]
        }
        
        return tabBarViewController
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = tabBarViewController
    }
}

extension TabBarCoordinator {
    func configureHomeCoordinator() {
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "homekit"),
            selectedImage: UIImage(systemName: "pencil")
        )
        let homeCoordinator = HomeScreenCoordinator(
            rootNavigationController: homeNavigationController
        )
        coordinators.append(homeCoordinator)
        viewControllers.append(homeNavigationController)
    }
}


