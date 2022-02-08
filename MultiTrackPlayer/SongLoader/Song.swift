//
//  Song.swift
//  AnikaApp
//
//  Created by Patrick Rugebregt on 04/02/2022.
//

import Foundation

enum Key: String, CaseIterable {
    case A
    case Bb
    case B
    case C
    case Db
    case D
    case Eb
    case E
    case F
    case Gb
    case G
    case Ab 
}

struct SongList {
    
    var songs = [Song]()
    
    init() {
        
        songs.append(Song(title: "RWY",
                          artist: "Michael Jackson",
                          instruments: [
                            .drums,
                            .bass,
                            .vocals,
                            .guitar,
                            .guitar,
                            .backingvocals,
                            .backingvocals,
                            .trumpet,
                            .other,
                            .other,
                            .keyboards,
                            .keyboards
                        ],
                          tempo: 115,
                          key: .Db))
        songs.append(Song(title: "backpocket",
                          artist: "VulfPeck",
                          instruments: [
                            .drums,
                            .bass,
                            .keyboards,
                            .guitar,
                            .trumpet,
                            .saxophone,
                            .vocals,
                            .backingvocals,
                            .percussion
                        ],
                          tempo: 90,
                          key: .Bb))
    }
    
}

struct Song {
    
    let title: String
    let artist: String
    let instruments: [Instrument]
    let tempo: Float
    let key: Key
    
}
