//
//  VideoPlayer.swift
//  
//
//  Created by Davis Allie on 7/2/2023.
//

import AVKit
import SwiftUI

public struct VideoPlayer: UIViewControllerRepresentable {
    
    let manager: VideoPlaybackManager
    public init(manager: VideoPlaybackManager) {
        self.manager = manager
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let player = AVPlayerViewController()
        player.showsPlaybackControls = false
        player.player = manager.mainPlayer
        player.videoGravity = .resizeAspectFill
        return player
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
}
