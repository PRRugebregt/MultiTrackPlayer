//
//  MusicPlayerTests.swift
//  MultiTrackPlayerTests
//
//  Created by Patrick Rugebregt on 08/02/2022.
//

import XCTest
import AVFoundation
@testable import MultiTrackPlayer

class MusicPlayerTests: XCTestCase {

    var sut: MockMusicPlayer?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MockMusicPlayer.shared
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testEngineHasStopped() throws {
        sut?.startEngine()
        XCTAssert(sut!.audioEngine.isRunning)
    }
    
    func testEngineIsConnected() throws {
        XCTAssert(sut!.audioEngine.attachedNodes.contains(where: {$0 == sut!.mainMixer}))
        XCTAssert(sut!.audioEngine.attachedNodes.contains(where: {$0 == sut!.trackMixer}))
        XCTAssert(sut!.audioEngine.attachedNodes.contains(where: {$0 == sut!.pitchNode}))
    }

}
