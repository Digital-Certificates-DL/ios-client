//
//  QrCropViewModel.swift
//  certificates-ios-client
//
//  Created by Apik on 17.05.2023.
//

import Foundation


protocol QrCropViewModelProvider: AnyObject {
    func parseQr(_ qrStringData: String)
    func dismiss()
}

class QrCropViewModel: QrCropViewModelProvider {
    enum Path {
        case dismiss
        case parseQr(data: String)
    }
    
    private let pathHandler: (QrCropViewModel.Path) -> Void
    private let model: QrCropModelProvider
    
    init(model: QrCropModelProvider, pathHandler: @escaping (QrCropViewModel.Path) -> Void) {
        self.model = model
        self.pathHandler = pathHandler
    }
    
    func dismiss() {
        
    }
    
    func parseQr(_ qrStringData: String) {
        pathHandler(.parseQr(data: qrStringData))
    }
}
