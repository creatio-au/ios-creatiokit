//
//  VideoPlaybackManager.swift
//  
//
//  Created by Davis Allie on 7/2/2023.
//

import AVFoundation
import Foundation

@MainActor
public class VideoPlaybackManager: ObservableObject {
    
    @Published public private(set) var playbackElapsed: Double = 0.0
    public private(set) var mainPlayer: AVPlayer
    private var observationToken: Any?
    
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    
    public init(asset: AVAsset, loops: Bool) {
        let playerItem = AVPlayerItem(asset: asset)
        
        if loops {
            let queuePlayer = AVQueuePlayer(playerItem: playerItem)
            let playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
            
            self.playerLooper = playerLooper
            self.queuePlayer = queuePlayer
            self.mainPlayer = queuePlayer
        } else {
            mainPlayer = AVPlayer(playerItem: playerItem)
        }
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        observationToken = mainPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.playbackElapsed = time.seconds
        }
    }
    
    deinit {
        if let observationToken {
            mainPlayer.removeTimeObserver(observationToken)
        }
    }
}
