//
//  Track.swift
//  AnikaApp
//
//  Created by Patrick Rugebregt on 08/02/2022.
//

import Foundation
import AVFoundation



class Track {
    
    let player: AVAudioPlayerNode
    let trackNumber: Int
    var savedVolume: Float = 1
    let instrument: Instrument
    var isSolo = false
    var isMuted = false
    
    init(player: AVAudioPlayerNode, trackNumber: Int, instrument: Instrument) {
        self.instrument = instrument
        self.player = player
        self.trackNumber = trackNumber
    }
    
    func changeSoloState() {
        isSolo = !isSolo
    }
    
    func changeMuteState() {
        isMuted = !isMuted
    }
    
}
