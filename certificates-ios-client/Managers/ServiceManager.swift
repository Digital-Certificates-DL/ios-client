//
//  ServiceManager.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/9/23.
//

import Foundation

protocol ServiceManagerProvider: AnyObject {
    
}

class ServiceManager: ServiceManagerProvider {
    static let shared: ServiceManagerProvider = ServiceManager()
    
    init() {
        
    }
    
}
