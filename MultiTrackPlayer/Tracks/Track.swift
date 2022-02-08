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
    var savedVolume: Float = 1
    
    init(player: AVAudioPlayerNode) {
        self.player = player
    }
    
}
