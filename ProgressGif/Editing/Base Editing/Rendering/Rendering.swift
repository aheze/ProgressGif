//
//  Rendering.swift
//  ProgressGif
//
//  Created by Zheng on 7/21/20.
//

import UIKit
import AVFoundation

extension ExportViewController {
    
    private func addProgressBar(to layer: CALayer, drawingSize: CGSize, configuration: EditableEditingConfiguration) {
        
        let progressBarBackgroundLayer = CALayer()
        progressBarBackgroundLayer.backgroundColor = configuration.barBackgroundColor.cgColor
        
        let height = configuration.barHeight.getBarHeightFromValue(withUnit: unit)
        
        progressBarBackgroundLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: drawingSize.width,
            height: height)
        
        progressBarBackgroundLayer.displayIfNeeded()
        layer.addSublayer(progressBarBackgroundLayer)
        
        let progressBarForegroundLayer = CALayer()
        progressBarForegroundLayer.backgroundColor = configuration.barForegroundColor.cgColor
        
        progressBarForegroundLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: drawingSize.width * 0.5,
            height: height)
        
        progressBarForegroundLayer.displayIfNeeded()
        layer.addSublayer(progressBarForegroundLayer)
        
    }
    
    /// to background, so need to calculate frame
    private func addShadow(to layer: CALayer, drawingRect: CGRect, configuration: EditableEditingConfiguration) {
        
        let insetPath = UIBezierPath(roundedRect: drawingRect, cornerRadius: configuration.edgeCornerRadius.getRadiusFromValue(withUnit: unit))

        let shadowLayer = CAShapeLayer()
        shadowLayer.path = insetPath.cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = configuration.edgeShadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowLayer.shadowOpacity = min(Float(configuration.edgeShadowIntensity) / 10, 1)
        
        let shadowRadius = configuration.edgeShadowRadius.getShadowRadiusFromValue(withUnit: unit)
        shadowLayer.shadowRadius = CGFloat(shadowRadius) * Constants.shadowRadiusMultiplier
        
        shadowLayer.displayIfNeeded()
        layer.addSublayer(shadowLayer)
        
        
    }
    
    private func maskCorners(for layer: CALayer, maskSize: CGSize, configuration: EditableEditingConfiguration) {
        
        let insetPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: maskSize), cornerRadius: configuration.edgeCornerRadius.getRadiusFromValue(withUnit: unit))

        let maskLayer = CAShapeLayer()
        maskLayer.path = insetPath.cgPath
        maskLayer.fillColor = UIColor.white.cgColor
        
        maskLayer.displayIfNeeded()
//        layer.addSublayer(shadowLayer)
        
        layer.mask = maskLayer
        
        
    }
    
    private func scaleVideoForInset(for videoLayer: CALayer, and overlayLayer: CALayer, videoSize: CGSize, configuration: EditableEditingConfiguration) {
        
        let scale = configuration.edgeInset.getScaleFromInsetValue()
        
        let adjustedVideoWidth = videoSize.width * scale
        let adjustedVideoHeight = videoSize.height * scale
        let adjustedVideoRect = CGRect(x: (videoSize.width - adjustedVideoWidth) / 2,
                                        y: (videoSize.height - adjustedVideoHeight) / 2,
                                        width: adjustedVideoWidth,
                                        height: adjustedVideoHeight)
        
        videoLayer.frame = adjustedVideoRect
        overlayLayer.frame = adjustedVideoRect
    }

    
    private func getAdjustedFrame(for videoSize: CGSize, configuration: EditableEditingConfiguration) -> CGRect {
        let scale = configuration.edgeInset.getScaleFromInsetValue()
        
        let adjustedVideoWidth = videoSize.width * scale
        let adjustedVideoHeight = videoSize.height * scale
        let adjustedVideoRect = CGRect(x: (videoSize.width - adjustedVideoWidth) / 2,
                                        y: (videoSize.height - adjustedVideoHeight) / 2,
                                        width: adjustedVideoWidth,
                                        height: adjustedVideoHeight)
        
        return adjustedVideoRect
    }
    
    
    func render(from asset: AVURLAsset, with configuration: EditableEditingConfiguration, onComplete: @escaping (URL?) -> Void) {
        
        let composition = AVMutableComposition()
        
        guard
            let compositionTrack = composition.addMutableTrack(
                withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
            let assetTrack = asset.tracks(withMediaType: .video).first
            else {
                onComplete(nil)
                print("Something is wrong with the asset.")
                return
        }
        
        
        do {
            // 1
            let timeRange = CMTimeRange(start: .zero, duration: asset.duration)
            // 2
            try compositionTrack.insertTimeRange(timeRange, of: assetTrack, at: .zero)
            
            // 3
            if let audioAssetTrack = asset.tracks(withMediaType: .audio).first,
                let compositionAudioTrack = composition.addMutableTrack(
                    withMediaType: .audio,
                    preferredTrackID: kCMPersistentTrackID_Invalid) {
                try compositionAudioTrack.insertTimeRange(
                    timeRange,
                    of: audioAssetTrack,
                    at: .zero)
            }
        } catch {
            // 4
            onComplete(nil)
            print(error)
            return
        }

        compositionTrack.preferredTransform = assetTrack.preferredTransform
        let videoInfo = orientation(from: assetTrack.preferredTransform)
        
        let videoSize: CGSize
        if videoInfo.isPortrait {
            videoSize = CGSize(
                width: assetTrack.naturalSize.height,
                height: assetTrack.naturalSize.width)
        } else {
            videoSize = assetTrack.naturalSize
        }
        
        let backgroundLayer = CALayer()
        backgroundLayer.frame = CGRect(origin: .zero, size: videoSize)
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)
        let overlayLayer = CALayer()
        overlayLayer.frame = CGRect(origin: .zero, size: videoSize)
        
        backgroundLayer.backgroundColor = UIColor.white.cgColor
        
        let adjustedVideoFrame = getAdjustedFrame(for: videoSize, configuration: configuration)
        
        videoLayer.frame = adjustedVideoFrame
        overlayLayer.frame = adjustedVideoFrame
        
        maskCorners(for: videoLayer, maskSize: adjustedVideoFrame.size, configuration: configuration)
        maskCorners(for: overlayLayer, maskSize: adjustedVideoFrame.size, configuration: configuration)
        
        addProgressBar(to: overlayLayer, drawingSize: adjustedVideoFrame.size, configuration: configuration)
        addShadow(to: backgroundLayer, drawingRect: adjustedVideoFrame, configuration: configuration)
        
//        scaleVideoForInset(for: videoLayer, and: overlayLayer, videoSize: videoSize, configuration: configuration)
        
        let outputLayer = CALayer()
        outputLayer.frame = CGRect(origin: .zero, size: videoSize)
        outputLayer.addSublayer(backgroundLayer)
        outputLayer.addSublayer(videoLayer)
        outputLayer.addSublayer(overlayLayer)

        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(
            postProcessingAsVideoLayer: videoLayer,
            in: outputLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(
            start: .zero,
            duration: composition.duration)
        videoComposition.instructions = [instruction]
        let layerInstruction = compositionLayerInstruction(
            for: compositionTrack,
            assetTrack: assetTrack)
        instruction.layerInstructions = [layerInstruction]

        guard let export = AVAssetExportSession(
            asset: composition,
            presetName: AVAssetExportPresetHighestQuality)
            else {
                onComplete(nil)
                print("Cannot create export session.")
                return
        }
        
        let videoName = UUID().uuidString
        let exportURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(videoName)
            .appendingPathExtension("mov")
        
        export.videoComposition = videoComposition
        export.outputFileType = .mov
        export.outputURL = exportURL

        //`AVAssetExportSession` code above
        var exportProgressBarTimer = Timer() // initialize timer
        
        exportProgressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.updateProgress(to: export.progress)
        }
        
        export.exportAsynchronously {
//            self.updateProgress(to: 100)
            exportProgressBarTimer.invalidate()
            
            DispatchQueue.main.async {
                switch export.status {
                case .completed:
                    print("Completed export! Export URL: \(exportURL)")
                    onComplete(exportURL)
                default:
                    print("Something went wrong during export.")
                    print(export.error ?? "unknown error")
                    onComplete(nil)
                    break
                }
            }
        }

        
        
        
    }
    
    private func compositionLayerInstruction(for track: AVCompositionTrack, assetTrack: AVAssetTrack) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let transform = assetTrack.preferredTransform
        
        instruction.setTransform(transform, at: .zero)
        
        return instruction
    }
    
    private func orientation(from transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        
        return (assetOrientation, isPortrait)
    }
}
