//
//  ViewController.swift
//  AnikaApp
//
//  Created by Patrick Rugebregt on 29/01/2022.
//

import UIKit

class PlayerViewController: UIViewController, Scrollable {

    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var trackScrollView: UIScrollView!
    @IBOutlet weak var playButton: UIButton!
    
    var musicPlayer: MusicPlayerProtocol = MusicPlayer.shared
    var numberOfTracks: Int = 0 {
        didSet {
            createAllTracks()
        }
    }
    var trackViews = [TrackViewController]()
    var isPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateSong(_:)), name: .loadNewTrack, object: nil)
        musicPlayer.delegate = self
        trackScrollView.delegate = self
        createAllTracks()
    }
    
    func createAllTracks() {
        var scrollHeight: CGFloat = 0
        self.children.forEach({$0.view.removeFromSuperview()})
        self.children.forEach({$0.removeFromParent()})
        for i in 0 ..< numberOfTracks {
            let trackView = TrackViewController(trackNumber: i, instrument: musicPlayer.instruments[i], track: musicPlayer.tracks[i], width: self.view.frame.size.width * 0.9)
            self.addChild(trackView)
            trackView.didMove(toParent: self)
            trackScrollView.addSubview(trackView.view)
            trackView.view.layer.position.y = CGFloat(i+1) * (trackView.view.frame.height + 30)
            scrollHeight += trackView.view.frame.height + 30
        }
        trackScrollView.contentSize = CGSize(width: trackScrollView.frame.width, height: scrollHeight)
    }
    
    @objc func updateSong(_ notification: Notification) {
        let newTracks = notification.userInfo?["tracks"] as! [Track]
        let newInstruments = notification.userInfo?["instrumentTracks"] as! [Instrument]
        musicPlayer.instruments = newInstruments
        musicPlayer.tracks = newTracks
        numberOfTracks = newTracks.count
    }
    
    func updateSlider(value: Float) {
        timeSlider.value = value
    }
    
    func incrementSlider(with value: Float) {
        timeSlider.value += value
    }

    @IBAction func playPressed(_ sender: Any) {
        isPlaying = !isPlaying
        if isPlaying {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            musicPlayer.playAllTracks()
        } else {
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            musicPlayer.pauseAllTracks()
        }
    }
    
    @IBAction func timeScrolling(_ sender: UISlider) {
        if sender.isSelected {
            musicPlayer.stopAllTracks()
        }
        musicPlayer.jumpAudio(to: sender.value)
    }
    
}

extension PlayerViewController: UIScrollViewDelegate {
}

extension Notification.Name {
    static let loadNewTrack = Notification.Name("loadNewTrack")
}
