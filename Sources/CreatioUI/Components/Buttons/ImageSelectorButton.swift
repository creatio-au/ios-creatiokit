//
//  ImageSelectorButton.swift
//  
//
//  Created by Davis Allie on 18/6/2022.
//

import SwiftUI

public struct ImageSelectorButton<MenuLabel: View>: View {
    
    @Binding var image: UIImage?
    private var menuLabel: MenuLabel
    
    @State private var isShowingCameraCapture = false
    @State private var isShowingImagePicker = false
    
    public init(image: Binding<UIImage?>, label: () -> MenuLabel) {
        self._image = image
        self.menuLabel = label()
    }
    
    public var body: some View {
        Menu {
            Button {
                isShowingCameraCapture = true
            } label: {
                Label("From camera", systemImage: "camera")
            }
            
            Button {
                isShowingImagePicker = true
            } label: {
                Label("From photo library", systemImage: "photo")
            }
        } label: {
            menuLabel
        }
        .fullScreenCover(isPresented: $isShowingCameraCapture.animation()) {
            CameraCapture(image: $image)
        }
        .fullScreenCover(isPresented: $isShowingImagePicker.animation()) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
    }
    
}
