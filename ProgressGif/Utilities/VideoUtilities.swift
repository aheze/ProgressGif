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
