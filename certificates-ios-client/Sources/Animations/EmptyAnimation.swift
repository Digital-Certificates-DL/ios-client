//
//  EmptyAnimation.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 30.06.2023.
//

import UIKit

class EmptyAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { .init(0.0) }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {}
}
