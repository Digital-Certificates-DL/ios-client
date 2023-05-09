//
//  Coordinator.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/9/23.
//

import Foundation

protocol Coordinator: AnyObject {
    var previousCoordinator: Coordinator? { get set }
    var currentCoordinator: Coordinator? { get set }
    func start()
}
