//
//  SideMenu.swift
//  
//
//  Created by Davis Allie on 29/4/2022.
//

import SwiftUI

struct SideMenu<MenuContent: View>: ViewModifier {
    
    @Binding var isShowing: Bool
    private let menuContent: () -> MenuContent
    
    public init(isShowing: Binding<Bool>,
                @ViewBuilder menuContent: @escaping () -> MenuContent) {
        _isShowing = isShowing
        self.menuContent = menuContent
    }
    
    func body(content: Content) -> some View {
        /*let drag = DragGesture().onEnded { event in
            if event.location.x < 200 && abs(event.translation.height) < 50 && abs(event.translation.width) > 50 {
                withAnimation {
                    self.isShowing = event.translation.width > 0
                }
            }
        }*/
        
        ZStack {
            content
            
            if isShowing {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .zIndex(5)
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                    .transition(.opacity)
                
                menuContent()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    //.offset(x: -20, y: 0)
                    .zIndex(10)
                    .transition(.move(edge: .leading))
            }
        }
    }
}

public extension View {
    func sideMenu<MenuContent: View>(
        isShowing: Binding<Bool>,
        @ViewBuilder menuContent: @escaping () -> MenuContent
    ) -> some View {
        self.modifier(SideMenu(isShowing: isShowing, menuContent: menuContent))
    }
}
