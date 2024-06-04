//
//  VideoWithTextOverlayView.swift
//  Text2Image
//
//  Created by Chima onyekwere on 5/30/24.
//

import SwiftUI
import AVFoundation
import AVKit

struct VideoWithTextOverlayView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return VideoOverlayViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No update needed
    }
}

class VideoOverlayViewController: UIViewController {
    var myurl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        saveVideo()
    }

    func saveVideo() {
        guard let path = Bundle.main.path(forResource: "sample_video", ofType: "mp4") else { return }
        let fileURL = NSURL(fileURLWithPath: path)

        let composition = AVMutableComposition()
        let vidAsset = AVURLAsset(url: fileURL as URL, options: nil)

        // get video track
        guard let videoTrack = vidAsset.tracks(withMediaType: AVMediaType.video).first else { return }
        let vid_timerange = CMTimeRangeMake(start: .zero, duration: vidAsset.duration)

        let tr: CMTimeRange = CMTimeRange(start: .zero, duration: CMTime(seconds: 10.0, preferredTimescale: 600))
        composition.insertEmptyTimeRange(tr)

        let trackID: CMPersistentTrackID = CMPersistentTrackID(kCMPersistentTrackID_Invalid)

        guard let compositionvideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: trackID) else { return }
        try? compositionvideoTrack.insertTimeRange(vid_timerange, of: videoTrack, at: .zero)
        compositionvideoTrack.preferredTransform = videoTrack.preferredTransform

        // Watermark Effect
        let size = videoTrack.naturalSize

        let imglogo = UIImage(named: "image.png")
        let imglayer = CALayer()
        imglayer.contents = imglogo?.cgImage
        imglayer.frame = CGRect(x: 5, y: 5, width: 100, height: 100)
        imglayer.opacity = 0.6

        // create text Layer
        let titleLayer = CATextLayer()
        titleLayer.backgroundColor = UIColor.white.cgColor
        titleLayer.string = "Dummy text"
        titleLayer.font = UIFont(name: "Helvetica", size: 28)
        titleLayer.shadowOpacity = 0.5
        titleLayer.alignmentMode = .center
        titleLayer.frame = CGRect(x: 0, y: 50, width: size.width, height: size.height / 6)

        let videolayer = CALayer()
        videolayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        let parentlayer = CALayer()
        parentlayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        parentlayer.addSublayer(videolayer)
        parentlayer.addSublayer(imglayer)
        parentlayer.addSublayer(titleLayer)

        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        layercomposition.renderSize = size
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)

        // instruction for watermark
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: .zero, duration: composition.duration)
        let videotrack = composition.tracks(withMediaType: .video)[0]
        let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
        instruction.layerInstructions = [layerinstruction]
        layercomposition.instructions = [instruction]

        // create new file to receive data
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0]
        let movieFilePath = (docsDir as NSString).appendingPathComponent("result.mov")
        let movieDestinationUrl = NSURL(fileURLWithPath: movieFilePath)

        // use AVAssetExportSession to export video
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        assetExport?.outputFileType = .mov
        assetExport?.videoComposition = layercomposition

        // Check exist and remove old file
        FileManager.default.removeItemIfExisted(movieDestinationUrl as URL)

        assetExport?.outputURL = movieDestinationUrl as URL
        assetExport?.exportAsynchronously(completionHandler: {
            switch assetExport!.status {
            case .failed:
                print("failed")
                print(assetExport?.error ?? "unknown error")
            case .cancelled:
                print("cancelled")
                print(assetExport?.error ?? "unknown error")
            default:
                print("Movie complete")
                self.myurl = movieDestinationUrl as URL
                self.playVideo()
            }
        })
    }

    func playVideo() {
        guard let url = myurl else { return }
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
        print("playing...")
    }
}

extension FileManager {
    func removeItemIfExisted(_ url: URL) {
        if fileExists(atPath: url.path) {
            try? removeItem(atPath: url.path)
        }
    }
}
