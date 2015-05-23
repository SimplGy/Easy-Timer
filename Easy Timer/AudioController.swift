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

//protocol PlayerDelegate : class {
//    func soundFinished(sender : AnyObject)
//}

class AudioController : NSObject {

    static let soundPath = "Sounds/"
    static let defaultSound = "chipper"
    var timerAudio: AVAudioPlayer!
    var flashbulb: Flashbulb!
    let maxVolume:Float = 240 // each channel of audio scales from -120 to 0, the loudest
    weak var delegate : AVAudioPlayerDelegate?
    
    // MARK: - Constructor
    override init(){
        super.init()
        var displayLink = CADisplayLink(target: self, selector: "updateVolume")
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }

    
    // MARK: - Instance Methods
    
    // Select one of the pieces of audio and ready it for playback
    // Play the audio and vibrate
    func play() {
        // Reset any existing values
        timerAudio?.delegate = nil
        timerAudio?.stop()
        
        // Select sound file at random from available ones
        var filename = getRandomSoundPath()
        // Sound path/reference
        var sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "aifc")!)
        // Prep
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        // Play sound
        var error: NSError?
        timerAudio = AVAudioPlayer(contentsOfURL: sound, error: &error)
        timerAudio.delegate = self
        timerAudio.meteringEnabled = true
        timerAudio.prepareToPlay()

        println("playing sound: \(filename)")
        timerAudio.play()
        vibrate()
    }
    func vibrate(){
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
    }
    
    // Update the visual display of volume, but only if we have audio, a flashbulb, and the audio is playing
    // Calculates the brightness of the flashbulb based on the present power of the audio
    func updateVolume() {
        if timerAudio == nil   { return }
        if flashbulb  == nil   { return }
        if !timerAudio.playing { return }
        timerAudio.updateMeters()
        var volume:Float = maxVolume
        for i in 0 ..< timerAudio.numberOfChannels {
            volume += timerAudio.averagePowerForChannel(i)
        }
        var alpha = CGFloat(volume / maxVolume)
        alpha = alpha - 0.5   // Shift the range over to the area with interesting differences in our source tracks
        alpha = pow(alpha, 3) // Emphases the changes in this range (negative values ignored)
        alpha *= 10
//        println("volume, alpha: \((volume, alpha))")
        flashbulb.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(alpha)
    }

    
    // MARK: Static Methods
    static func getRandomSoundName() -> String {
        var name = defaultSound
        
        let path = NSBundle.mainBundle().bundlePath + "/" + AudioController.soundPath
        var error: NSError? = nil
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(path, error: &error)

        if let results = contents {
            let randomIndex = Int(arc4random_uniform(UInt32(results.count)))
            if let filename = results[randomIndex] as? String {
                name = filename
            } else {
                println("couldn't cast results at random index to string")
            }
        } else {
            println("no files found: \(error)")
        }
        
        return name
    }
    
    
    // MARK: - Private Methods
    private func getRandomSoundPath() -> String {
        var filename = AudioController.getRandomSoundName()
        let randomSound = filename.stringByDeletingPathExtension
        return AudioController.soundPath + randomSound
    }
    
    deinit {
        self.timerAudio?.delegate = nil
    }
}

extension AudioController : AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(AVAudioPlayer!, successfully: Bool) {
        //        self.delegate?.soundFinished(self) // TODO: why would I need to call this? Understand delegates.
        if flashbulb == nil { return }
        flashbulb.backgroundColor = UIColor.clearColor()
        
    }
}

