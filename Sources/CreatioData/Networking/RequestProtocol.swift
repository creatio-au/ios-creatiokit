//
//  RequestProtocol.swift
//  
//
//  Created by Davis Allie on 27/4/2022.
//

import Foundation

public struct RequiredAuthenticationError: LocalizedError {
    public var errorDescription: String? {
        return "Missing authentication data for request that requires authentication"
    }
}

internal protocol RequestProtocol {
    
    var path: String { get }
    var method: HttpMethod { get }
    var requiresAuthentication: Bool { get }
        
}
