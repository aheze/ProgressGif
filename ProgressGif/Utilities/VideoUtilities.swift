//
//  VideoUtilities.swift
//  ProgressGif
//
//  Created by Zheng on 7/17/20.
//

import Foundation
import AVFoundation

extension AVAsset {
    func resolutionSizeForLocalVideo(url:NSURL) -> CGSize? {
        guard let track = self.tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}
