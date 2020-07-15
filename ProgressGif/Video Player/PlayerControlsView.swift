//
//  PlayerControlsView.swift
//  ProgressGif
//
//  Created by Zheng on 7/13/20.
//

import UIKit

enum PlayingState {
    case playing
    case paused
}
enum SliderEvent {
    case began
    case moved
    case ended
}
protocol PlayerControlsDelegate: class {
    func backPressed()
    func forwardPressed()
    func sliderChanged(value: Float, event: SliderEvent)
    func changedPlay(playingState: PlayingState)
}

class PlayerControlsView: UIView {
    
    weak var playerControlsDelegate: PlayerControlsDelegate?
    
    var playingState = PlayingState.paused

    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var customSlider: CustomSlider!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var back5Button: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forward5Button: UIButton!
    
    @IBAction func backPressed(_ sender: Any) {
        playerControlsDelegate?.backPressed()
    }
    @IBAction func playPressed(_ sender: Any) {
        if playingState == .playing {
            playingState = .paused
            playButton.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        } else {
            playingState = .playing
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        
        playerControlsDelegate?.changedPlay(playingState: playingState)
    }
    
    
    
    func stop() {
        playingState = .paused
        playButton.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
    }
    func backToBeginning() {
        customSlider.setValue(0, animated: true)
    }
    
    @IBAction func forwardPressed(_ sender: Any) {
        playerControlsDelegate?.forwardPressed()
    }
    
    
    @IBAction func sliderChangedValue(_ sender: Any, forEvent event: UIEvent) {
        
        if let touchEvent = event.allTouches?.first {
            
            var sliderEvent = SliderEvent.began
            
            switch touchEvent.phase {
            case .began:
                sliderEvent = .began
            case .moved:
                sliderEvent = .moved
            case .ended:
                sliderEvent = .ended
            default:
                break
            }
            playerControlsDelegate?.sliderChanged(value: customSlider.value, event: sliderEvent)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlayerControlsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setUp()
    }
    
    func setUp() {
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 10
        customSlider.setThumbImage(UIImage(named: "circle"), for: .normal)
        customSlider.isContinuous = true
    }
}



