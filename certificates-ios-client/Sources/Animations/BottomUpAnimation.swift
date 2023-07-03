//
//  bottomUpAnimation.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 30.06.2023.
//

import UIKit

class BottomUpAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { .init(0.5) }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.isHidden = true
        let yOffset = toViewController.view.frame.maxY
        toViewController.view.frame.origin.y += yOffset
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toViewController.view.isHidden = false
            toViewController.view.frame.origin.y -= yOffset
        }
    }
}
