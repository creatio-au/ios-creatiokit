//
//  CameraPreview.swift
//  DevolverUI
//
//  Created by Davis Allie on 16/4/2022.
//

import AVFoundation
import SwiftUI

public struct CameraPreview: UIViewRepresentable {
    
    let captureSession: AVCaptureSession
    public init(captureSession: AVCaptureSession) {
        self.captureSession = captureSession
    }
    
    public func makeUIView(context: Context) -> some UIView {
        let view = VideoView()
        view.previewLayer.session = captureSession
        view.previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer.connection?.videoOrientation = .portrait
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        (uiView as? VideoView)?.previewLayer.session = captureSession
    }
    
    private class VideoView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }
    
}
