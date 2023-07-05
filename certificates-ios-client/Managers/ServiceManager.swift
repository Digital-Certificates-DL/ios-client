//
//  ServiceManager.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/9/23.
//

import Foundation

protocol ServiceManagerProvider: AnyObject {
    static var shared: ServiceManagerProvider { get }
    var apiManager: ApiClientProvider { get }
    var reposManager: ReposManagerProvider { get }
}

class ServiceManager: ServiceManagerProvider {
    static let shared: ServiceManagerProvider = ServiceManager()
    private(set) var apiManager: ApiClientProvider
    private(set) var reposManager: ReposManagerProvider
    private let configuration: Config
    
    init() {
        configuration = Config()
        apiManager = ApiClient(configuration: configuration)
        reposManager = ReposManager(apiManager: apiManager)
    }
}
