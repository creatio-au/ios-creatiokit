//
//  FormCondition.swift
//  
//
//  Created by Davis Allie on 11/5/2022.
//

import Foundation

public struct FormCondition {
    
    var closure: () -> Bool
    
    internal init(_ expression: @escaping () -> Bool) {
        self.closure = expression
    }
    
    internal init(_ expression: @autoclosure @escaping () -> Bool) {
        self.init(expression)
    }
    
    internal init(value: String, matchingRegexPattern pattern: String) {
        self.init {
            value.range(of: pattern, options: .regularExpression) != nil
        }
    }
    
}

public extension FormCondition {
    
    static func notEmpty(_ string: String) -> FormCondition {
        .init(string != "")
    }
    
    static func validEmail(_ string: String) -> FormCondition {
        // RFC 5322 regex (http://emailregex.com)
        let emailPattern = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        return .init(value: string, matchingRegexPattern: emailPattern)
    }
    
    static func complexPassword(_ string: String) -> FormCondition {
        let passwordPattern =
            // At least 8 characters
            #"(?=.{8,})"# +

            // At least one capital letter
            #"(?=.*[A-Z])"# +
                
            // At least one lowercase letter
            #"(?=.*[a-z])"# +
                
            // At least one digit
            #"(?=.*\d)"# +
                
            // At least one special character
            #"(?=.*[ !$%&?._-])"#
        
        return .init(value: string, matchingRegexPattern: passwordPattern)
    }
    
    static func expression(_ expression: @autoclosure @escaping () -> Bool) -> FormCondition {
        .init(expression)
    }
    
    static func combinedByOr(_ conditions: FormCondition...) -> FormCondition {
        .init {
            for condition in conditions {
                if condition.closure() {
                    return true
                }
            }
            
            return false
        }
    }
    
    static func combinedByAnd(_ conditions: FormCondition...) -> FormCondition {
        .init {
            for condition in conditions {
                if !condition.closure() {
                    return false
                }
            }
            
            return true
        }
    }
    
}
