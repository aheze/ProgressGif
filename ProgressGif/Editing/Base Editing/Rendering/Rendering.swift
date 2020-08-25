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
        
        let adjustedWidth = drawingSize.width * 1.05 /// extend out a little
        
        let progressBarBackgroundLayer = CALayer()
        progressBarBackgroundLayer.backgroundColor = configuration.barBackgroundColor.cgColor
        
        let height = configuration.barHeight.getBarHeightFromValue(withUnit: unit)
        
        let startRect = CGRect(x: 0, y: 0, width: 0, height: height)
        let endRect = CGRect(x: 0, y: 0, width: adjustedWidth, height: height)
        
        progressBarBackgroundLayer.frame = endRect
        
        progressBarBackgroundLayer.displayIfNeeded()
        layer.addSublayer(progressBarBackgroundLayer)
        
        let progressBarForegroundLayer = CALayer()
        progressBarForegroundLayer.backgroundColor = configuration.barForegroundColor.cgColor
        progressBarForegroundLayer.frame = startRect
        progressBarForegroundLayer.displayIfNeeded()
        
        progressBarForegroundLayer.bounds = CGRect(x: 0, y: 0, width: adjustedWidth, height: height)
        progressBarForegroundLayer.position = CGPoint(x: 0, y: 0)
        progressBarForegroundLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        let boundsAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.bounds))
        
        boundsAnimation.fromValue = NSValue(cgRect: startRect)
        boundsAnimation.toValue = NSValue(cgRect: endRect)
        
        boundsAnimation.duration = CMTimeGetSeconds(renderingAsset.duration)
        boundsAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        boundsAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
        progressBarForegroundLayer.add(boundsAnimation, forKey: "bounds animation")

        
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
        
        layer.mask = maskLayer
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
                print("Something is wrong with the asset.")
                onComplete(nil)
                return
        }
        
        do {
            let timeRange = CMTimeRange(start: .zero, duration: asset.duration)
            try compositionTrack.insertTimeRange(timeRange, of: assetTrack, at: .zero)
            
        } catch {
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
        
        /// the clear background + shadow
        let backgroundLayer = CALayer()
        backgroundLayer.frame = CGRect(origin: .zero, size: videoSize)
        
        /// the video
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)
        
        /// progress bar
        let overlayLayer = CALayer()
        overlayLayer.frame = CGRect(origin: .zero, size: videoSize)
        
        backgroundLayer.backgroundColor = UIColor.clear.cgColor
        
        /// adjust for edge insets
        let adjustedVideoFrame = getAdjustedFrame(for: videoSize, configuration: configuration)
        
        videoLayer.frame = adjustedVideoFrame
        overlayLayer.frame = adjustedVideoFrame
        
        /// add corner radius
        maskCorners(for: videoLayer, maskSize: adjustedVideoFrame.size, configuration: configuration)
        maskCorners(for: overlayLayer, maskSize: adjustedVideoFrame.size, configuration: configuration)
        
        addProgressBar(to: overlayLayer, drawingSize: adjustedVideoFrame.size, configuration: configuration)
        addShadow(to: backgroundLayer, drawingRect: adjustedVideoFrame, configuration: configuration)
        
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
            assetTrack: assetTrack, orientation: videoInfo.orientation)
        instruction.layerInstructions = [layerInstruction]

        if #available(iOS 13.0, *) {
            export = AVAssetExportSession(
                asset: composition,
                presetName: AVAssetExportPresetHEVCHighestQualityWithAlpha)
        } else {
            export = AVAssetExportSession(
            asset: composition,
            presetName: AVAssetExportPresetHighestQuality)
            // Fallback on earlier versions
        }
       
        guard let exportSession = export
            else {
                onComplete(nil)
                print("Cannot create export session.")
                return
        }
        
        let videoName = UUID().uuidString
        let exportURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(videoName)
            .appendingPathExtension("mov")
        
        exportSession.videoComposition = videoComposition
        exportSession.outputFileType = .mov
        exportSession.outputURL = exportURL

        /// export progress timer
        var exportProgressBarTimer = Timer() // initialize timer
        
        exportProgressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            
            /// update the progress label
            self.updateProgress(to: exportSession.progress)
        }
        
        print("start export")
        exportSession.exportAsynchronously {
            exportProgressBarTimer.invalidate()
            DispatchQueue.main.async {
                switch exportSession.status {
                case .completed:
                    print("Completed export! Export URL: \(exportURL)")
                    onComplete(exportURL)
                default:
                    print("Something went wrong during export.")
                    print(exportSession.error ?? "unknown error")
                    onComplete(nil)
                    break
                }
            }
        }
    }
    
    private func compositionLayerInstruction(for track: AVCompositionTrack, assetTrack: AVAssetTrack, orientation: UIImage.Orientation) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        
        var transform = CGAffineTransform.identity
        let assetSize = assetTrack.naturalSize
        
        switch orientation {
        case .up:
            transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
        case .down:
            transform = CGAffineTransform(a: -1, b: 0, c: 0, d: -1, tx: assetSize.width, ty: assetSize.height)
        case .left:
            transform = CGAffineTransform(a: 0, b: -1, c: 1, d: 0, tx: 0, ty: assetSize.width)
        case .right:
            transform = CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: assetSize.height, ty: 0)
         default:
            print("DEFAULT ERROR")
        }
        
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

//extension CGAffineTransform {
//    func getOrientation() -> (orientation: UIImage.Orientation, isPortrait: Bool) {
//        var assetOrientation = UIImage.Orientation.up
//        var isPortrait = false
//        if self.a == 0 && self.b == 1.0 && self.c == -1.0 && self.d == 0 {
//            assetOrientation = .right
//            isPortrait = true
//        } else if self.a == 0 && self.b == -1.0 && self.c == 1.0 && self.d == 0 {
//            assetOrientation = .left
//            isPortrait = true
//        } else if self.a == 1.0 && self.b == 0 && self.c == 0 && self.d == 1.0 {
//            assetOrientation = .up
//        } else if self.a == -1.0 && self.b == 0 && self.c == 0 && self.d == -1.0 {
//            assetOrientation = .down
//        }
//
//        return (assetOrientation, isPortrait)
//    }
//}
