//
//  QrScreenViewModel .swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/12/23.
//

import Foundation


protocol QrScreenViewModelProvider: AnyObject {
    func parseQr(_ qrStringData: String)
    func dismiss()
}

class QrScreenViewModel: QrScreenViewModelProvider {
    
    enum Path {
        case dismiss
        case parseQr(data: String)
    }
    
    private let pathHandler: (QrScreenViewModel.Path) -> Void
    private let model: QrScreenModelProvider
    
    init(model: QrScreenModelProvider, pathHandler: @escaping (QrScreenViewModel.Path) -> Void) {
        self.model = model
        self.pathHandler = pathHandler
    }
    
    func dismiss() {
        
    }
    
    func parseQr(_ qrStringData: String) {
        pathHandler(.parseQr(data: qrStringData))
    }
    
}
