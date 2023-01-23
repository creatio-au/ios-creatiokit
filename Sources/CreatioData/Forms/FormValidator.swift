//
//  FormValidator.swift
//  
//
//  Created by Davis Allie on 11/5/2022.
//

import Foundation

public protocol FormValidator {
    var conditions: [FormCondition] { get }
}

public extension FormValidator {
    
    func isFormInvalid() -> Bool {
        for condition in conditions {
            if !condition.closure() {
                return true
            }
        }
        
        return false
    }
    
}
