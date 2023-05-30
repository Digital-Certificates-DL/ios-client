//
//  InfoScreenModel.swift
//  certificates-ios-client
//
//  Created by Apik on 11.05.2023.
//

import UIKit

protocol InfoScreenModelProvider: AnyObject {
    func getAllTitles() -> [InfoScreenTableViewDataSource.Item]
    func getAllButtons() -> [InfoScreenTableViewDataSource.Item]
    func getAllTimes() -> [InfoScreenTableViewDataSource.Item]
    func getAllInfoItems() -> [InfoScreenTableViewDataSource.Item]
    func getDataForCopy() -> String
}

class InfoScreenModel: InfoScreenModelProvider{
    private typealias Title = InfoScreenTableViewDataSource.Item
    private typealias Button = InfoScreenTableViewDataSource.Item
    private typealias Time = InfoScreenTableViewDataSource.Item
    private typealias Status = InfoScreenTableViewDataSource.Item
    
    private let validatedCertificate: QrDataValidated
    
    init(validatedCertificate: QrDataValidated) {
        self.validatedCertificate = validatedCertificate
    }
    
    func getAllTitles() -> [InfoScreenTableViewDataSource.Item] {
        let message: Title = Title.itemTitle(title: "message", content: validatedCertificate.message)
        let address: Title = Title.itemTitle(title: "address", content: validatedCertificate.address)
        let signature: Title = Title.itemTitle(title: "signature", content: validatedCertificate.signature)
        let certificatePage: Title = Title.itemTitle(title: "certificate Page", content: validatedCertificate.certificatePage ?? "")
        
        return [message, address, signature, certificatePage]
    }
    
    func getDataForCopy() -> String {
        let message = "message: \n\(validatedCertificate.message)\n\n"
        let address = "address: \n\(validatedCertificate.address)\n\n"
        let signature = "signature: \n\(validatedCertificate.signature)\n\n"
        let certificatePage = "certificate page: \n\(validatedCertificate.certificatePage)\n\n"
        return message + address + signature + certificatePage
    }
    
    func getAllButtons() -> [InfoScreenTableViewDataSource.Item] {
        let copyButton: Button = Button.itemButton(title: "Copy", icon: .ic_copy)
        let shareButton: Button = Button.itemButton(title: "Share", icon: .ic_share)
        
        return [copyButton, shareButton]
    }
    
    func getAllInfoItems() -> [InfoScreenTableViewDataSource.Item] {
        return getStatus() + getAllTitles() + getAllTimes() + getAllButtons()
    }
    
    
    func getAllTimes() -> [InfoScreenTableViewDataSource.Item] {
        return [Time.itemTime(time: validatedCertificate.date)]
    }
    
    func getStatus() -> [InfoScreenTableViewDataSource.Item] {
        return [Status.itemStatus(isConfirmed: validatedCertificate.certificateIsValid)]
    }
}
