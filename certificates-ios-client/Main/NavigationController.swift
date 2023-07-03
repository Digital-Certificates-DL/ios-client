//
//  NavigationController.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 30.06.2023.
//

import UIKit

class NavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setup()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {}
    
    func startLoader(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let viewController = LoaderScreenViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true) {
            completion?()
        }
    }
    
    func pushViewController(_ viewController: UIViewController, from: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .moveIn
        transition.subtype = from
        view.layer.add(transition, forKey: kCATransition)
        super.pushViewController(viewController, animated: false)
    }
    
    func popToViewController(_ viewController: UIViewController, from: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .reveal
        transition.subtype = from
        view.layer.add(transition, forKey: kCATransition)
        super.popToViewController(viewController, animated: false)
    }
    
    func popViewController(from: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .reveal
        transition.subtype = from
        view.layer.add(transition, forKey: kCATransition)
        super.popViewController(animated: false)
    }
    
    func stopLoader(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        self.dismiss(animated: true) {
            completion?()
        }
    }
}
