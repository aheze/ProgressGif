//
//  PhotoPageViewController+UpdateSliderProgress.swift
//  ProgressGif
//
//  Created by Zheng on 7/13/20.
//

import UIKit

extension PhotoPageViewController: UpdateSliderProgress {
    
    func updateSlider(to value: Float) {
        playerControlsView.customSlider.setValue(value, animated: false)
    }
}
