//
//  TrackViewController.swift
//  AnikaApp
//
//  Created by Patrick Rugebregt on 29/01/2022.
//

import UIKit
import AVFAudio

enum Instrument: String {
    case drums
    case bass
    case guitar
    case keyboards
    case trumpet
    case saxophone
    case vocals
    case backingvocals
    case percussion
    case other
}

class TrackViewController: UIViewController {

    @IBOutlet weak var instrumentImage: UIImageView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var soloButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var musicPlayer: MusicPlayerProtocol = MusicPlayer.shared
    private let width: CGFloat
    private let track: Track
    
    init(trackNumber: Int, instrument: Instrument, track: Track, width: CGFloat) {
        self.width = width
        self.track = track
        super.init(nibName: "TrackViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muteButton.alpha = 0.3
        soloButton.alpha = 0.3
        self.view.frame.size.width = width
        instrumentImage.image = UIImage(named: track.instrument.rawValue)
    }
    
    @IBAction func volumeSliderAction(_ sender: UISlider) {
        print("volume changed for \(track.instrument)")
        track.player.volume = sender.value
        track.savedVolume = sender.value
    }
    
    @IBAction func soloButtonPressed(_ sender: Any) {
        track.changeSoloState()
        soloButton.alpha = !track.isSolo ? 0.3 : 1
        musicPlayer.soloTrack(number: track.trackNumber, isSolod: track.isSolo)
    }
    
    @IBAction func muteButtonPressed(_ sender: UIButton) {
        track.changeMuteState()
        muteButton.alpha = !track.isMuted ? 0.3 : 1
        if track.isMuted {
            track.player.volume = 0
        } else {
            track.player.volume = 1
        }
    }
    
}
