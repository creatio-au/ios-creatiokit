//
//  AuthenticationModel.swift
//  
//
//  Created by Davis Allie on 16/7/2022.
//

import Foundation

@MainActor
@available(iOS 14.5, *)
open class AuthenticationModel: ObservableObject {
    
    @Published public private(set) var authenticationToken: String?
    @Published public private(set) var refreshToken: String?
    @Published public var isLoggedIn = false
    
    private var keychainService: KeychainService
    
    public init(keychainService: KeychainService = .standard, loadImmediately: Bool = true) {
        self.keychainService = keychainService
        
        if loadImmediately {
            loadFromKeychain()
            isLoggedIn = authenticationToken != nil
        }
    }
    
    public func loadFromKeychain() {
        authenticationToken = keychainService.string(forKey: "authentication_token", withAccessibility: .whenUnlocked)
        refreshToken = keychainService.string(forKey: "refresh_token", withAccessibility: .whenUnlocked)
    }
    
    public func updateTokens(authentication: String? = nil, refresh: String? = nil, keychainAccessibility: KeychainItemAccessibility = .whenUnlocked) {
        if let newAuthentication = authentication {
            keychainService.set(newAuthentication, forKey: "authentication_token", withAccessibility: keychainAccessibility)
            isLoggedIn = true
        }
        
        if let newRefresh = refresh {
            keychainService.set(newRefresh, forKey: "refresh_token", withAccessibility: keychainAccessibility)
        }
    }
    
    public func deleteTokens() {
        authenticationToken = nil
        refreshToken = nil
        
        keychainService.removeObject(forKey: "authentication_token")
        keychainService.removeObject(forKey: "refresh_token")
        
        isLoggedIn = false
    }
    
}
