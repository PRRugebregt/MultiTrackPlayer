//
//  SongLoader.swift
//  AnikaApp
//
//  Created by Patrick Rugebregt on 04/02/2022.
//

import Foundation
import AVFoundation

enum FileError: String, Error {
    case invalidURL = "One of the file URLs was invalid. Please report this to the app developer"
    case fileIsEmpty = "Files were loaded, but seem to be empty. Please report this to the app developer"
    case notAllSameLength = "Not all the files are the same length. Check audio bounces"
}

class SongLoader {
    
    var song: Song?
    var delegate: SongLoaderViewController?
    private var tracks = [Track]()
    private var musicPlayer: MusicPlayerProtocol = MusicPlayer.shared
    private var loadedInstruments = [String]()
    
    func changeSong(to song: Song) {
        tracks = []
        self.song = song
        musicPlayer.chosenSong = song
        do {
            try loadAllInstruments()
        } catch {
            print(error)
        }
    }
    
    func loadAllInstruments() throws {
        let instruments = song!.instruments
        for i in instruments.indices {
            do {
            let file = try loadAudioFile(for: instruments[i].rawValue)
            let player = AVAudioPlayerNode()
            let track = Track(player: player, trackNumber: i, instrument: instruments[i])
            tracks.append(track)
            musicPlayer.addTrackToPlayer(audioPlayer: player, from: file, numberOfTracks: song!.instruments.count)
            } catch {
                let descriptionError = error as! FileError
                song = nil
                loadedInstruments = []
                tracks = []
                DispatchQueue.main.async {
                    self.delegate?.showAlert(title: "Woops", message: "\(descriptionError.rawValue)")
                }
                throw descriptionError
            }
        }
        
        NotificationCenter.default.post(name: .loadNewTrack, object: nil, userInfo: [
            "instrumentTracks":song!.instruments,
            "tracks":tracks])
    }
    
    func loadAudioFile(for instrument: String) throws -> AVAudioFile {
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
        if let url = Bundle.main.path(forResource: "\(song!.title)_\(instrument)\(count)", ofType: "mp3") {
            do {
                file = try AVAudioFile(forReading: URL(fileURLWithPath: url))
                guard file.length > 0 else { throw FileError.fileIsEmpty }
            } catch {
                print("error opening file \(error.localizedDescription)")
            }
        } else {
            throw FileError.invalidURL
        }
        return file
    }
    
}
