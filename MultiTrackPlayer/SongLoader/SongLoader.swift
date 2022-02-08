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
    private var tracks = [Track]()
    private var musicPlayer: MusicPlayerProtocol = MusicPlayer.shared
    private var loadedInstruments = [String]()
    
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
        var count = ""
        // Needs fixing. Not very elegant
        if loadedInstruments.contains(where: {$0 == instrument}) {
            var c: Int {
                var count = 0
                for instr in loadedInstruments {
                    if instr == instrument {
                        count += 1
                    }
                }
                return count
            }
            count = "\(c+1)"
        }
        
        loadedInstruments.append(instrument)
        let url = Bundle.main.path(forResource: "\(song!.title)_\(instrument)\(count)", ofType: "mp3")
        do {
            file = try AVAudioFile(forReading: URL(fileURLWithPath: url!))
        } catch {
            print("error opening file \(error.localizedDescription)")
        }
        return file
    }
    
}
