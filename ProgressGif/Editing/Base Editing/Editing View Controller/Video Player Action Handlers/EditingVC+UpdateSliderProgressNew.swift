//
//  EditingVC+UpdateSliderProgress.swift
//  ProgressGif
//
//  Created by Zheng on 7/15/20.
//

import UIKit

extension EditingViewController: UpdateSliderProgress {
    func updateSlider(to value: Float) {
        playerControlsView.customSlider.setValue(value, animated: false)
        updateProgressBar(to: value, animated: false)
    }
    
    func finishedVideo() {
        playerControlsView.stop()
    }
}
