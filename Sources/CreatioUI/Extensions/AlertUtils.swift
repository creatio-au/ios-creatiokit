//
//  AlertUtils.swift
//  
//
//  Created by Davis Allie on 11/5/2022.
//

import Foundation
import SwiftUI

struct SimpleAlertModifier<Item: Hashable, Actions: View, Message: View>: ViewModifier {
    
    let title: String
    @Binding var item: Item?
    
    let actionsBuilder: (Item) -> Actions
    let messageBuilder: (Item) -> Message
    
    private var itemExistsBinding: Binding<Bool> {
        .init {
            item != nil
        } set: { value in
            if !value {
                item = nil
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: itemExistsBinding, presenting: item, actions: actionsBuilder, message: messageBuilder)
    }
    
}

public extension View {
    
    func alert<Item: Hashable, Actions: View, Message: View>(_ title: String, presenting: Binding<Item?>, @ViewBuilder actions: @escaping (Item) -> Actions, @ViewBuilder message: @escaping (Item) -> Message) -> some View {
        self.modifier(SimpleAlertModifier(title: title, item: presenting, actionsBuilder: actions, messageBuilder: message))
    }
    
}
