//
//  View+Snapshot.swift
//  
//
//  Created by Davis Allie on 20/10/2022.
//

import SwiftUI

public extension View {
    
    func snapshot(size: CGSize? = nil) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = size ?? controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
}
