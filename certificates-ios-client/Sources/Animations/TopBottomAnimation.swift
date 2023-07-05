//
//  TopBottomAnimationDismiss.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 30.06.2023.
//

import Foundation

import UIKit

class TopBottomAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { .init(0.5) }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        transitionContext.containerView.addSubview(fromViewController.view)
//        fromViewController.view.isHidden = true
        let yOffset = fromViewController.view.frame.maxY
        fromViewController.view.frame.origin.y -= yOffset
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
//            fromViewController.view.isHidden = false
            fromViewController.view.frame.origin.y += yOffset
        }
    }
}
