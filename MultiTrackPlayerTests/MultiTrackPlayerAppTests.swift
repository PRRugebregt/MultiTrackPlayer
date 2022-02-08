//
//  AnikaAppTests.swift
//  AnikaAppTests
//
//  Created by Patrick Rugebregt on 29/01/2022.
//

import XCTest
@testable import AnikaApp

class AnikaAppTests: XCTestCase {

    var sut: SongLoader?
    
    override func setUpWithError() throws {
        try! super.setUpWithError()
        sut = SongLoader()
        sut?.song = Song(title: "Booom", artist: "Anika Nilles", instruments: [.drums,.guitar,.keyboards], tempo: 120, key: .Bb)
    }

    override func tearDownWithError() throws {
        try! super.tearDownWithError()
    }

    func testNumberOfInstruments() throws {

        let numberOfInstruments = sut?.song?.instruments.count
        sut?.loadAllInstruments()
        XCTAssert(sut?.tracks.count == numberOfInstruments)
        XCTAssert(sut?.musicPlayer.audioFiles.count == numberOfInstruments)
        XCTAssert(sut?.musicPlayer.audioPlayers.count == numberOfInstruments)
        XCTAssert(sut?.musicPlayer.numberOfTracks == numberOfInstruments)
    
    }
    
    func testStopAudio() throws {
        sut?.loadAllInstruments()
        let musicplayer = MusicPlayer.shared
        musicplayer.removeAllTracks()
        XCTAssert(!musicplayer.audioEngine.isRunning)
        XCTAssert(musicplayer.audioFiles.isEmpty)
        XCTAssert(musicplayer.audioPlayers.isEmpty)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            sut?.loadAllInstruments()
        }
    }

}
