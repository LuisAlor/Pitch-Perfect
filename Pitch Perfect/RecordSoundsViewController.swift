//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Luis Vazquez on 12.04.2020.
//  Copyright © 2020 Alortechs. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
   
    // MARK: - Record Audio Button (action)
    @IBAction func recordAudio(_ sender: Any) {
        
        //Configure UI Elements when recording
        configUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        // Set RecordSoundsViewController as delegate of AVAudioRecorder
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    // MARK: - Stop Recording Button (action)
    @IBAction func stopRecording(_ sender: Any) {
      
        //Configure UI Elements when not recording
        configUI(isRecording: false)
        
        // Stop Audio Recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // Check if audio was saved successfully or not
        if flag {
            // Programmatically perform Segue to PlaySoundsViewController
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording failed!")
        }
    }
    // MARK: - Config UI Elements
    func configUI(isRecording: Bool){
        //If the recording is in process configure the UI as follows
        if isRecording{
            recordingLabel.text = "Recording in progress"
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        }
        else{
            recordingLabel.text = "Tap to Record"
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    // MARK: - Prepare Segue Actions for PlaySoundsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // Check if this is the segue we want "stopRecording"
        if segue.identifier == "stopRecording" {
            //Grab viewcontroller we are transitioning
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            // Grab sender and upcast to URL
            let recordedAudioURL = sender as! URL
            // Set audio URL to PlaySoundsViewController
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}
