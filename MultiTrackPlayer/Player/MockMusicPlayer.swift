//
//  MockMusicPlayer.swift
//  AnikaApp
//
//  Created by Patrick Rugebregt on 07/02/2022.
//

import Foundation
import AVFoundation

class MockMusicPlayer: MusicPlayerProtocol {
    
    static let shared = MockMusicPlayer()
    
    private let session = AVAudioSession.sharedInstance()
    private let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)

    var audioEngine = AVAudioEngine()
    var mainMixer = AVAudioMixerNode()
    var trackMixer = AVAudioMixerNode()
    var audioPlayers = [AVAudioPlayerNode]()
    var audioFiles = [AVAudioFile]()
    var numberOfTracks = 0
    private var now = AVAudioFramePosition(0)
    private var timer = Timer()
    private var songLength: AVAudioFrameCount?
    private var stoppedTime: AVAudioTime = AVAudioTime(sampleTime: AVAudioFramePosition(0), atRate: 44100)
    private var sampleRate: Double = 44100
    
    var pitchNode = AVAudioUnitTimePitch()
    var delegate: Scrollable?
    var chosenSong: Song?
    var tracks = [Track]()
    var instruments = [Instrument]()
    
    init() {
        audioEngine.attach(mainMixer)
        audioEngine.attach(pitchNode)
        audioEngine.attach(trackMixer)
        audioEngine.connect(trackMixer, to: pitchNode, format: audioFormat)
        self.audioEngine.connect(self.pitchNode, to: self.mainMixer, format: self.audioFormat)
            self.audioEngine.connect(self.mainMixer, to: self.audioEngine.outputNode, format: self.audioFormat)
        do {
            try session.setCategory(.playAndRecord)
        } catch {
            print(error)
        }
        print(session.outputVolume)
    }
    
    func addTrackToPlayer(audioPlayer: AVAudioPlayerNode, from file: AVAudioFile, numberOfTracks: Int) {
        self.numberOfTracks = numberOfTracks
        songLength = AVAudioFrameCount(file.length)
        sampleRate = file.fileFormat.sampleRate
        audioPlayers.append(audioPlayer)
        audioFiles.append(file)
        audioEngine.attach(audioPlayer)
        audioEngine.connect(audioPlayer, to: trackMixer, format: audioFormat)
        audioPlayer.scheduleFile(file, at: nil, completionHandler: nil)
        if audioPlayers.count == numberOfTracks {
            startEngine()
        }
    }
    
    func removeAllTracks() {
        audioEngine.stop()
        audioEngine.reset()
        for player in audioPlayers {
            player.stop()
            audioEngine.detach(player)
        }
        delegate?.updateSlider(value: 0)
        audioFiles.removeAll()
        audioPlayers.removeAll()
    }
    
    func startEngine() {
        do {
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print(error)
        }
    }
    
    @objc func scrollSlider() {
        let songLengthInSeconds = Float(songLength!) / Float(sampleRate)
        let increment: Float = 1 / songLengthInSeconds
        delegate?.incrementSlider(with: increment)
    }
    
    func playAllTracks() {
        guard audioPlayers.first != nil else {
            return
        }
        let now = audioPlayers.first!.lastRenderTime?.sampleTime ?? AVAudioFramePosition(0)
        let startTime = AVAudioTime(sampleTime: now, atRate: sampleRate)
        startTimer()
        for player in audioPlayers {
            print("started")
            player.play(at: startTime)
        }
    }
    
    func stopAllTracks() {
        stopTimer()
        let lastRenderTime = audioPlayers.first!.lastRenderTime?.sampleTime
        print(lastRenderTime!)
        print(songLength!)
        stoppedTime = AVAudioTime(sampleTime: lastRenderTime!, atRate: sampleRate)
        for player in audioPlayers {
            player.stop()
        }
    }
    
    func pauseAllTracks() {
        stopTimer()
        for player in audioPlayers {
            player.pause()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scrollSlider), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func jumpAudio(to value: Float) {
        stopAllTracks()
        now = AVAudioFramePosition(Float(songLength!) * value)
        delegate?.updateSlider(value: value)
        startTimer()
        for i in 0 ..< audioPlayers.count {
            audioPlayers[i].scheduleSegment(audioFiles[i], startingFrame: now, frameCount: songLength!, at: AVAudioTime(sampleTime: 0, atRate: sampleRate), completionHandler: nil)
            audioPlayers[i].play(at: AVAudioTime(sampleTime: AVAudioFramePosition(0.1), atRate: 44100))
        }
    }
    
    func soloTrack(number: Int, isSolod: Bool) {
        if !isSolod {
            for i in audioPlayers.indices {
                guard i != number else { continue }
                audioPlayers[i].volume = 0
            }
        } else {
            for i in audioPlayers.indices {
                audioPlayers[i].volume = 1
            }
        }
    }
    
}

