//
//  String + PopFirst.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 29.06.2023.
//

import Foundation

extension String {
    func popFirst() -> String {
        var resultString = ""
        
        var i = 0
        
        for character in self {
            if i == 0 {
                i += 1
                continue
            }
            
            resultString += String(character)
            
        }
        
        return resultString
        
    }
}
