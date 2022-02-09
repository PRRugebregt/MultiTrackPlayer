//
//  AnikaAppTests.swift
//  AnikaAppTests
//
//  Created by Patrick Rugebregt on 29/01/2022.
//

import XCTest
@testable import MultiTrackPlayer

class MultiTrackPlayerAppTests: XCTestCase {

    var sut: SongLoader?
    var song: Song?
    
    override func setUpWithError() throws {
        try! super.setUpWithError()
        sut = SongLoader()
        song = Song(title: "backpocket",
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
                         key: .Bb)
    }

    override func tearDownWithError() throws {
        try! super.tearDownWithError()
    }

    func testNumberOfInstruments() throws {
        sut?.changeSong(to: song!)
        var fetchedNotification: Notification?
        let numberOfInstruments = sut?.song?.instruments.count
        do {
            try sut?.loadAllInstruments()
        } catch {
            let fullError = error as! FileError
            XCTAssertNotNil(fetchedNotification, fullError.rawValue)
            return
        }
        expectation(forNotification: .loadNewTrack, object: nil) { notification in
            fetchedNotification = notification
            let newTracks = notification.userInfo?["tracks"] as! [Track]
            let newInstruments = notification.userInfo?["instrumentTracks"] as! [Instrument]
            XCTAssert(newTracks.count == numberOfInstruments)
            XCTAssert(newInstruments.count == numberOfInstruments)
            return true
        }
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
        
    }
    
    func testChangingSong() throws {
        sut?.changeSong(to: song!)
        XCTAssertNotNil(sut?.song)
    }

}
