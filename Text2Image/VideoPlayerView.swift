//
//  VideoPlayerView.swift
//  Text2Image
//
//  Created by Chima onyekwere on 6/18/24.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(frame: .zero, url: url)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

class PlayerUIView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    init(frame: CGRect, url: URL) {
        super.init(frame: frame)
        setupPlayer(url: url)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupPlayer(url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer!)
        player?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}


