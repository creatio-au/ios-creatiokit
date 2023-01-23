//
//  AsyncButton.swift
//  
//
//  Created by Davis Allie on 2/4/2022.
//

import SwiftUI

public struct AsyncButton<Label: View>: View {
    
    let action: (() async throws -> Void)
    let label: Label
    
    @State private var isRunningAction = false
    @Environment(\.errorHandler) var errorHandler
    
    public init(action: @escaping (() async throws -> Void), label: () -> Label) {
        self.action = action
        self.label = label()
    }
    
    public var body: some View {
        Button {
            isRunningAction = true
            Task {
                do {
                    try await action()
                } catch {
                    errorHandler.handle(error)
                }
                
                isRunningAction = false
            }
        } label: {
            ZStack {
                label.opacity(isRunningAction ? 0.0 : 1.0)
                
                if isRunningAction {
                    ProgressView()
                }
            }
        }
        .disabled(isRunningAction)
    }
    
}

public extension AsyncButton where Label == Text {
    init(_ title: String, action: @escaping (() async throws -> Void)) {
        self.init(action: action) {
            Text(title)
        }
    }
}

struct AsyncButton_Previews: PreviewProvider {
    
    static func dummyTask() async {
        try! await Task.sleep(nanoseconds: 2_000_000_000)
    }
    
    static var previews: some View {
        VStack {
            AsyncButton {
                await dummyTask()
            } label: {
                Text("Button")
            }
            .disabled(false)
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
    }
}
