//
//  AudioController.swift
//  Manages the instantiation and playback of audio
//
//  Created by Eric on 3/4/15.
//  Copyright (c) 2015 Simple Guy. All rights reserved.
//

//import AudioToolbox
import AVFoundation
import UIKit


class AudioController : NSObject {

    // MARK: - Instance variables and constants
    var timerAudio: AVAudioPlayer!
    var flashbulb: Flashbulb!
    let soundPath = "Sounds/"
    let defaultSound = "chipper"
    let maxVolume:Float = 320
    
    
    // MARK: - Constructor
    override init(){
        super.init()
        var displayLink = CADisplayLink(target: self, selector: "updateVolume")
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    // set the UI View used to display the flashing visual
//    func setFlasher(flasher: Flashbulb!){
//        flashbulb = flasher
//    }

    // MARK: - Instance Methods
    // Select one of the pieces of audio and ready it for playback
    // Play the audio and vibrate
    func play(#flasher: Flashbulb!){
        // Save the flasher, a view which will flash with the volume
        flashbulb = flasher
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
        timerAudio.meteringEnabled = true
        timerAudio.prepareToPlay()

        println("playing sound: \(filename)")
        timerAudio.play()
        vibrate()
        
    }
    func vibrate(){
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
    }
    
    func updateVolume() {
//      if let playing = timerAudio?.playing {
        if timerAudio != nil && timerAudio.playing {
            timerAudio.updateMeters()
            var volume:Float = maxVolume - 100 // the range is from -320 to 0 for two channels of db
            for i in 0 ..< timerAudio.numberOfChannels {
                volume += timerAudio.averagePowerForChannel(i)
            }
            println("volume: \(volume)")
            if flashbulb != nil {
                var alpha = CGFloat(volume / maxVolume) // TODO: scale this so that the peaks are more obvious
                println("alpha: \(alpha)")
                flashbulb.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(alpha)
            }
        } else if flashbulb != nil { // TODO: better way to turn off the flashbulb when audio finishes
            flashbulb.backgroundColor = UIColor.clearColor()
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

