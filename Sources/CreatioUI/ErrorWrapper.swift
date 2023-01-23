//
//  ErrorWrapper.swift
//  
//
//  Created by Davis Allie on 4/5/2022.
//

import Foundation
import SwiftUI

public class ErrorWrapper: ObservableObject {
    
    @Published public var error: Error?
    
    public var hasErrorBinding: Binding<Bool> {
        .init { [weak self] in
            self?.error != nil
        } set: { [weak self] value in
            if !value {
                self?.error = nil
            }
        }
    }
    
    public init() {}
    
}
