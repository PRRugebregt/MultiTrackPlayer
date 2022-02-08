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
    
    let trackNumber: Int
    let instrument: Instrument
    let width: CGFloat
    let track: Track
    var musicPlayer: MusicPlayerProtocol = MusicPlayer.shared
    private var isSolo = false
    private var isMuted = false
    
    init(trackNumber: Int, instrument: Instrument, track: Track, width: CGFloat) {
        self.width = width
        self.track = track
        self.instrument = instrument
        self.trackNumber = trackNumber
        print(instrument)

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
        instrumentImage.image = UIImage(named: instrument.rawValue)
    }
    
    @IBAction func volumeSliderAction(_ sender: UISlider) {
        print("volume changed for \(instrument)")
        track.player.volume = sender.value
        track.savedVolume = sender.value
    }
    
    @IBAction func soloButtonPressed(_ sender: Any) {
        isSolo = !isSolo
        soloButton.alpha = !isSolo ? 0.3 : 1
        musicPlayer.soloTrack(number: trackNumber, isSolod: isSolo)
    }
    
    @IBAction func muteButtonPressed(_ sender: UIButton) {
        isMuted = !isMuted
        muteButton.alpha = !isMuted ? 0.3 : 1
        if isMuted {
            track.player.volume = 0
        } else {
            track.player.volume = 1
        }
    }
    
}
