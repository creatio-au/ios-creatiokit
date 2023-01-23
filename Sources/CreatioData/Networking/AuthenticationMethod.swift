//
//  AuthenticationMethod.swift
//  
//
//  Created by Davis Allie on 27/4/2022.
//

import Foundation

public enum AuthenticationMethod {
    
    case unauthenticated, bearerToken(String)
    
}
