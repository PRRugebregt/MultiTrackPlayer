//
//  SongLoader.swift
//  AnikaApp
//
//  Created by Patrick Rugebregt on 04/02/2022.
//

import Foundation
import AVFoundation

class SongLoader {
    
    var song: Song?
    var tracks = [Track]()
    var musicPlayer: MusicPlayerProtocol = MusicPlayer.shared
    
    func changeSong(to song: Song) {
        tracks = []
        self.song = song
        musicPlayer.chosenSong = song
        loadAllInstruments()
    }
    
    func loadAllInstruments() {
        for instrument in song!.instruments {
            let file = loadAudioFile(for: instrument.rawValue)
            let player = AVAudioPlayerNode()
            let track = Track(player: player)
            tracks.append(track)
            musicPlayer.addTrackToPlayer(audioPlayer: player, from: file, numberOfTracks: song!.instruments.count)
        }
        NotificationCenter.default.post(name: .loadNewTrack, object: nil, userInfo: [
            "instrumentTracks":song!.instruments,
            "tracks":tracks])
    }
    
    func loadAudioFile(for instrument: String) -> AVAudioFile {
        var file = AVAudioFile()
        let url = Bundle.main.path(forResource: "\(song!.title)_\(instrument)", ofType: "mp3")
        do {
            file = try AVAudioFile(forReading: URL(fileURLWithPath: url!))
        } catch {
            print("error opening file \(error.localizedDescription)")
        }
        return file
    }
    
}
