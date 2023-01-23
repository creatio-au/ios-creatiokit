//
//  AsyncNavigationLink.swift
//  
//
//  Created by Davis Allie on 27/4/2022.
//

import SwiftUI

public struct AsyncNavigationLink<Destination: View, Label: View>: View {
    
    let customErrorHandling: Bool
    let action: (() async throws -> Void)
    let label: Label
    let destination: Destination
    
    @State private var hasCompletedAction = false
    @Environment(\.errorHandler) var errorHandler
    
    public init(customErrorHandling: Bool = false, action: @escaping (() async throws -> Void), destination: () -> Destination, label: () -> Label) {
        self.customErrorHandling = customErrorHandling
        self.action = action
        self.destination = destination()
        self.label = label()
    }
    
    public var body: some View {
        AsyncButton {
            do {
                try await action()
                hasCompletedAction = true
            } catch {
                if !customErrorHandling {
                    errorHandler.handle(error)
                }
            }
        } label: {
            label
                .hiddenNavigationLink(isActive: $hasCompletedAction) {
                    destination
                }
        }
    }
    
}

struct AsyncNavigationLink_Previews: PreviewProvider {
    
    static func dummyTask() async {
        try! await Task.sleep(nanoseconds: 2_000_000_000)
    }
    
    static var previews: some View {
        VStack {
            AsyncNavigationLink {
                await dummyTask()
            } destination: {
                Text("Destination")
            } label: {
                Text("Button")
                    .padding(8)
                    .frame(maxWidth: .infinity)
            }
            .disabled(true)
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
    }
}
