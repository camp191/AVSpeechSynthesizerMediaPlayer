//
//  ViewController.swift
//  Synthesizer
//
//  Created by Thanapat Sorralump on 8/1/2564 BE.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class ViewController: UIViewController {
    let synth = AVSpeechSynthesizer()
    
    let mockText: String = "Test Test Test Test Test Test Test Test Test Test Test Test Test Test"
    
    func setupCommand() {
        MPRemoteCommandCenter.shared().playCommand.addTarget { [weak self] (event) in
            self?.synth.continueSpeaking()
            return .success
        }
        
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { [weak self] (event) in
            self?.synth.pauseSpeaking(at: .immediate)
            return .success
        }
    }
    
    func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Test !!!"
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func clearNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    @IBAction func speak(_ sender: UIButton) {
        setCategory(category: .playback)
        setupCommand()
        let utterance = AVSpeechUtterance(string: mockText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.volume = 1.0
        synth.speak(utterance)
        setupNowPlaying()
    }
    
    @IBAction func stop(_ sender: UIButton) {
        synth.stopSpeaking(at: .immediate)
        setCategory(category: .ambient)
        clearNowPlaying()
    }
    
    private func setCategory(category: AVAudioSession.Category) {
        do {
            try AVAudioSession.sharedInstance().setCategory(category)
        } catch {
            print(error)
        }
    }
}

