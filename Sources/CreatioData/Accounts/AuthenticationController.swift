//
//  AuthenticationController.swift
//  
//
//  Created by Davis Allie on 27/4/2022.
//

import Foundation

@MainActor
public class AuthenticationController: ObservableObject {
    
    public var isLoggedIn: Bool {
        authenticationToken != nil
    }
    
    @Published public private(set) var authenticationToken: String?
    @Published public private(set) var refreshToken: String?
    
    private var keychainService: KeychainService
    
    public init(keychainService: KeychainService = .standard, loadImmediately: Bool = true) {
        self.keychainService = keychainService
        
        if loadImmediately {
            loadFromKeychain()
        }
    }
    
    public func loadFromKeychain() {
        authenticationToken = keychainService.string(forKey: "authentication_token", withAccessibility: .whenUnlocked)
        refreshToken = keychainService.string(forKey: "refresh_token", withAccessibility: .whenUnlocked)
    }
    
    public func updateTokens(authentication: String? = nil, refresh: String? = nil, keychainAccessibility: KeychainItemAccessibility = .whenUnlocked) {
        if let newAuthentication = authentication {
            authenticationToken = newAuthentication
            keychainService.set(newAuthentication, forKey: "authentication_token", withAccessibility: keychainAccessibility)
        }
        
        if let newRefresh = refresh {
            refreshToken = newRefresh
            keychainService.set(newRefresh, forKey: "refresh_token", withAccessibility: keychainAccessibility)
        }
    }
    
    public func deleteTokens() {
        authenticationToken = nil
        refreshToken = nil
        
        keychainService.removeObject(forKey: "authentication_token")
        keychainService.removeObject(forKey: "refresh_token")
    }
    
}
