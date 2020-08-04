//
//  VideoUtilities.swift
//  ProgressGif
//
//  Created by Zheng on 7/17/20.
//

import UIKit
import AVFoundation

extension AVAsset {
    func resolutionSize() -> CGSize? {
        guard let track = self.tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}

extension TimeInterval {
    func getFormattedString() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        
        if let formattedDuration = formatter.string(from: self) {
            let firstTwoCharacters = String(formattedDuration.prefix(2))
            
            if firstTwoCharacters == "00" {
                var adjustedDuration = formattedDuration
                adjustedDuration.remove(at: formattedDuration.startIndex)
                return adjustedDuration
//                cell.nameLabel.text = adjustedDuration
            } else {
                return formattedDuration
//                cell.nameLabel.text = formattedDuration
            }
        } else {
            return nil
        }
    }
}
extension URL {
    func generateImageAsync(atTime time: CMTime = CMTimeMake(value: 1, timescale: 60)) -> UIImage? {
        let asset: AVAsset = AVAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
            return nil
        }
    }
    func generateImageAndDuration() -> (UIImage?, String?) {
        
        let asset: AVAsset = AVAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let duration = CMTimeGetSeconds(asset.duration)
        let durationString = duration.getFormattedString()

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return (UIImage(cgImage: thumbnailImage), durationString)
        } catch let error {
            print(error)
            return (nil, durationString)
        }
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    func generateImage(atTime time: CMTime = CMTimeMake(value: 1, timescale: 60), completion: @escaping ((_ image: UIImage?) -> Void )) {
        DispatchQueue.global().async {
            let asset: AVAsset = AVAsset(url: self)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            do {
                let thumbnailImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                
                let uiImage = UIImage(cgImage: thumbnailImage)
                DispatchQueue.main.async {
                    completion(uiImage)
                }
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
}
