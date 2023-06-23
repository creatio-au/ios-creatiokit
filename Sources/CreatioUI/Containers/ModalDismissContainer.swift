//
//  ModalDismissContainer.swift
//  
//
//  Created by Davis Allie on 23/6/2023.
//

import SwiftUI

public struct ModalDismissContainer<Content: View>: View {
    
    var title: String
    var content: Content
    
    public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    @Environment(\.dismiss) var dismissAction
    
    public var body: some View {
        NavigationView {
            content
                .navigationTitle(Text(title))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismissAction()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                        }
                    }
                }
        }
    }
    
}
