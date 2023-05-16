//
//  ClipboardManager.swift
//  certificates-ios-client
//
//  Created by Apik on 16.05.2023.
//

import UIKit

class ShereManager {
    static func shereText(text: String, vc: UIViewController) {
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        vc.present(activityViewController, animated: true, completion: nil)
    }
}
