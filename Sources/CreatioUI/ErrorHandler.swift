//
//  ErrorHandler.swift
//  
//
//  Created by Davis Allie on 4/5/2022.
//

import Foundation
import SwiftUI

public struct ErrorHandler {
    public var action: (Error) -> Void
    public init(action: @escaping (Error) -> Void) {
        self.action = action
    }
    
    public func handle(_ error: Error) {
        // Don't show alert for cancellations
        if let error = error as? URLError, error.code == .cancelled {
            return
        }
        
        self.action(error)
    }
    
    public struct EnvironmentKey: SwiftUI.EnvironmentKey {
        static public let defaultValue: ErrorHandler = ErrorHandler { _ in }
    }
    
    public static func linkedTo(wrapper: ErrorWrapper) -> ErrorHandler {
        .init { error in
            wrapper.error = error
        }
    }
}

public extension EnvironmentValues {
    var errorHandler: ErrorHandler {
        get { self[ErrorHandler.EnvironmentKey.self] }
        set { self[ErrorHandler.EnvironmentKey.self] = newValue }
    }
}
