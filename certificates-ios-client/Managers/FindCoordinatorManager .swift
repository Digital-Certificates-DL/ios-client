//
//  FindCoordinatorManager .swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 15.05.2023.
//

import UIKit

protocol FindCoordinatorManagerProvider: AnyObject {
    static var shared: FindCoordinatorManagerProvider { get }

    func findCoordinatorReverse<T>(
        _ fromCoordinator: Coordinator,
        findCoordinatorType: T.Type
    ) -> T? where T: Coordinator
    
    func findCoordinator<T>(
        _ fromCoordinator: Coordinator,
        findCoordinatorType: T.Type
    ) -> T? where T: Coordinator
}


class FindCoordinatorManager: FindCoordinatorManagerProvider {
    static let shared: FindCoordinatorManagerProvider = FindCoordinatorManager()
    
    func findCoordinatorReverse<T>(
        _ fromCoordinator: Coordinator,
        findCoordinatorType: T.Type
    ) -> T? where T: Coordinator {
        var currentCoordinator: Coordinator? = fromCoordinator
        var resultCoordinator: T? = nil
        while currentCoordinator != nil {
            if let currentCoordinator = currentCoordinator as? T {
                resultCoordinator = currentCoordinator
            }
            currentCoordinator = currentCoordinator?.previousCoordinator
        }
        return resultCoordinator
    }
    
    func findCoordinator<T>(
        _ fromCoordinator: Coordinator,
        findCoordinatorType: T.Type
    ) -> T? where T: Coordinator {
        var currentCoordinator: Coordinator? = fromCoordinator
        var resultCoordinator: T? = nil
        while currentCoordinator != nil {
            if let currentCoordinator = currentCoordinator as? T {
                resultCoordinator = currentCoordinator
            }
            currentCoordinator = currentCoordinator?.currentCoordinator
        }
        return resultCoordinator
    }
}
