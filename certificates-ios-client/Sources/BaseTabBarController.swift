//
//  BaseTabBarController.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/9/23.
//

import UIKit

class BaseTabBarController: UITabBarController {
    var completion: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.layer.addSublayer(configureTopBorder())
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBar(self.tabBar, didSelect: self.tabBar.items![0])
    }
    
    func configureTopBorder() -> CALayer {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 0.5)
        topBorder.backgroundColor = UIColor.systemGray3.cgColor
        return topBorder
    }
}

extension BaseTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
        var index = 0
        for tabBarItem in items {
            if tabBarItem == item { break }
            index += 1
        }
        completion?(index)
    }
}
