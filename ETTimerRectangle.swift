//
//  ETTimer.swift
//  Extends UIView.
//  * Draws the rectangle that represents remaining time.
//  * Creates the timer
//  * Displays the numeric time
//  * Reacts to taps and drags by changing remaining time
//
//  Created by Eric on 6/8/14.
//  Copyright (c) 2014 Simple Guy. All rights reserved.
//

import UIKit


class ETTimerUIView: UIView {
    
    @IBOutlet var timeDisplay : UILabel!
    @IBOutlet var secDisplay : UILabel!
    @IBOutlet var flashbulb: Flashbulb!

    let limit: CGFloat         = 60.0 * 60.0    // What's the maximum amount of time you can set a timer for?
    let tickAmount: CGFloat    = 1.0            // 1.0 means: one tick per second
    let timerInterval: CGFloat = 1 / 60 / 60    // Should be`tickAmount`. Smaller values are for debugging a fast clock.
    var percentage: CGFloat    = 0.0            // How much time is left, as a percentage of `limit`
    var remaining: CGFloat     = 0.0            // How much time is remaining right now?
    var prevRemaining: CGFloat = 0.0            // On the last tick, how much time was remaining?
    var setTime: CGFloat       = 0.0            // How much time has the user asked for a timer to run?
    var audioController = AudioController()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder) // this sounds like a superhero ring. TODO: What is an NSCoder and who invited it to the
        var timer = NSTimer.scheduledTimerWithTimeInterval(
            NSTimeInterval(timerInterval),
            target: self,
            selector: "tick",
            userInfo: nil,
            repeats: true)
        timer.tolerance = Double(timerInterval) * 0.1 // perf gain by allowing fuzzy times.
//        flashBg()
    }
    
    func setTimeDisplay() {
        timeDisplay.text = String(Int(remaining) / 60)
        var seconds = String(Int(remaining % 60))
        if countElements(seconds) == 1 {
            seconds = "0" + seconds
        }
        secDisplay.text = seconds
        self.setNeedsDisplay()
    }
    
    // Every step of the timer calls this method
    func tick() {
        if remaining > 0 {                          // Timer is running
            prevRemaining = remaining
            remaining = round(remaining)
            remaining -= tickAmount
            percentage = remaining / limit
            setTimeDisplay()
        } else if remaining != prevRemaining {      // Timer has *just* reached zero or slightly below
            println("just reached zero")
            remaining = 0.0
            prevRemaining = 0.0
            setTimeDisplay()
            audioController.play()
            flashBg()
        }                                           // No `else`; timer is idle. Good-fer-nuthin'.
    }
    
    // Given a position, set the time remaining on the timer
    func setRemainingTimeByPos(yOffset: CGFloat) {
        // Get size and percentage from bottom
        let height = self.frame.height
        let distFromBottom = height - yOffset
        let ratio = distFromBottom / height
        percentage = ratio
        // Get amount of time remaining
        remaining = percentage * limit
//        println("Tapped: \(distFromBottom) from the bottom. Height is \(height), so it's \(percentage*100)% full.")
        setTimeDisplay()
    }
    
    
    
    func flashBg() {

//        self.backgroundColor = UIColor.greenColor()
//        var color = self.tintColor
//        self.backgroundColor = color
//        var mode = self.tintAdjustmentMode
        
        
//        let animation = CABasicAnimation(keyPath: "position.x")
//        animation.fromValue = 0
//        animation.toValue = 317
        
        

        flashbulb.fire()
        
        
        
        
    }
    
    
    
    // Given a Y offset, set the height of the timer rectangle.
    // The timer rectangle fills up the screen from the bottom.
//    func setTimer(yOffset: Double) {
//        let height = Double(self.frame.height)
//        let distFromBottom = height - yOffset
//        let ratio = distFromBottom / height
//        percentage = ratio
//
//
//    }
    
    @IBAction func onDrag(recognizer: UIPanGestureRecognizer) {
        setRemainingTimeByPos(recognizer.locationInView(self).y)
    }
    
    @IBAction func onTap(recognizer: UITapGestureRecognizer) {
        setRemainingTimeByPos(recognizer.locationInView(self).y)
    }

    // Draw the timer at the value of timer remaining
    override func drawRect(var rect: CGRect)
    {
        var size = self.frame.height
        var height:CGFloat = size * percentage
        var top = self.frame.height - height
        var opacity = percentage + 0.5
        var context = UIGraphicsGetCurrentContext()
        CGContextSetRGBFillColor(context, 0.0, 0.5, 1.0, opacity)
        rect = CGRectMake(0, top, rect.width, height)
        CGContextFillRect(context, rect)
    }

    

    
    
}
