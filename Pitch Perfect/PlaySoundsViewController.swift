//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Luis Vazquez on 13.04.2020.
//  Copyright © 2020 Alortechs. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton:UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    enum ButtonType: Int { case slow = 0, fast, chipmunk, vader, echo, reverb }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize Audio Engine
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Disable stop button
        configureUI(.notPlaying)
    }
    
    // MARK: - Play Sounds Switch Selector (action)
    @IBAction func playSoundForButton(_ sender:UIButton){
       
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        //Enable stop button
        configureUI(.playing)
    }
    
    // MARK: - Audio Stop Button (action)
    @IBAction func stopButtonPressed(_ sender: AnyObject){
        stopAudio()
    }
}
