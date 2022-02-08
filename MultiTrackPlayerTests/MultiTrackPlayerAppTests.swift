//
//  AnikaAppTests.swift
//  AnikaAppTests
//
//  Created by Patrick Rugebregt on 29/01/2022.
//

import XCTest
@testable import MultiTrackPlayer

class AnikaAppTests: XCTestCase {

    var sut: SongLoader?
    
    override func setUpWithError() throws {
        try! super.setUpWithError()
        sut = SongLoader()
        sut?.song = Song(title: "backpocket",
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

        let numberOfInstruments = sut?.song?.instruments.count
        expectation(forNotification: .loadNewTrack, object: nil) { notification in
            let newTracks = notification.userInfo?["tracks"] as! [Track]
            let newInstruments = notification.userInfo?["instrumentTracks"] as! [Instrument]
            XCTAssert(newTracks.count == numberOfInstruments)
            XCTAssert(newInstruments.count == numberOfInstruments)
            return true
        }
        sut?.loadAllInstruments()
        waitForExpectations(timeout: 2, handler: nil)
        
    }

}
