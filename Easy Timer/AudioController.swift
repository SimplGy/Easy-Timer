//
//  AudioController.swift
//  Manages the instantiation and playback of audio
//
//  Created by Eric on 3/4/15.
//  Copyright (c) 2015 Simple Guy. All rights reserved.
//

//import AudioToolbox
import AVFoundation


class AudioController : NSObject {

    // MARK: - Instance variables and constants
    var timerAudio = AVAudioPlayer()
    let soundPath = "Sounds/"
    let defaultSound = "chipper"
    
    // MARK: - Constructor
    override init(){
        super.init()
//        timerAudio.meteringEnabled = true
//        var displayLink = CADisplayLink(target: self, selector: "updateVolume")
//        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    // MARK: - Instance Methods
    // Select one of the pieces of audio and ready it for playback
    // Play the audio and vibrate
    func play(){
        // Select sound file at random from available ones
        var filename = getRandomSound()
        // Sound path/reference
        var sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "aifc")!)
        // Prep
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        // Play sound
        var error: NSError?
        timerAudio = AVAudioPlayer(contentsOfURL: sound, error: &error)
        timerAudio.prepareToPlay()

        println("playing sound: \(filename)")
        timerAudio.play()
        vibrate()
        
    }
    func vibrate(){
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
    }
    
    func updateVolume() {
        println("updateVolume()")
        if timerAudio.playing {
            timerAudio.updateMeters()
            var volume = timerAudio.averagePowerForChannel(0)
            println("volume: \(volume)")
        }
    }

        
    // MARK: - Private Methods
    private func getRandomSound() -> String {
        let path = NSBundle.mainBundle().bundlePath + "/" + soundPath
//        println("path: \(path)")
        var error: NSError? = nil
        
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(path, error: &error)
        if contents == nil {
            println("no files found: \(error)")
            return defaultSound
        }
        let filenames = contents as [String]
        let randomIndex = Int(arc4random_uniform(UInt32(filenames.count)))
        let randomSound = filenames[randomIndex].stringByDeletingPathExtension
        return soundPath + randomSound
    }
    
    
}

