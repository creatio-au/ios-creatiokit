//
//  ThrowingTask.swift
//  
//
//  Created by Davis Allie on 4/5/2022.
//

import Foundation
import SwiftUI

@MainActor
public struct ThrowingTaskModifer: ViewModifier {
    
    let task: () async throws -> Void
    @Environment(\.errorHandler) var errorHandler
    
    public func body(content: Content) -> some View {
        content
            .task {
                do {
                    try await task()
                } catch {
                    errorHandler.handle(error)
                }
            }
    }
    
}

@MainActor
public extension View {
    func taskThrowing(_ task: @escaping () async throws -> Void) -> some View {
        self.modifier(ThrowingTaskModifer(task: task))
    }
}
