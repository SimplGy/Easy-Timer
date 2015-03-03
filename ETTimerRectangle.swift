//
//  ETTimer.swift
//  Easy Timer
//
//  Created by Eric on 6/8/14.
//  Copyright (c) 2014 Simple Guy. All rights reserved.
//

import UIKit

class ETTimerUIView: UIView {
    
    // The default boilerplate has a useless signature for init. bug? TODO: something I don't understand.
    //    init(frame: CGRect) {
    //        super.init(frame: frame)
    //        // Initialization code
    //
    //        println("custom view")
    //    }
    
    
    // TODO:
    // o Color by sinebow
    // o While dragging, snap to nearest 5 min increment
    // o Change color by time remaining from set (not total)
    // o fit seconds to minutes
    
    @IBOutlet var timeDisplay : UILabel!
    @IBOutlet var secDisplay : UILabel!
    
    let limit: CGFloat       = 60.0 * 60.0 // a 60 minute timer
    let interval: CGFloat    = 1.0
    var percentage: CGFloat  = 0.0
    var remaining: CGFloat   = 0.0
    

//    var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("tick"), userInfo: nil, repeats: true)
//    var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("tick"), userInfo: nil, repeats: true)

        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder) // this sounds like a superhero ring. TODO: What is an NSCoder and who invited it to the party?
        println("In ETTimerRectangle")
        var timer = NSTimer.scheduledTimerWithTimeInterval(
            NSTimeInterval(interval),
            target: self,
            selector: "tick",
            userInfo: nil,
            repeats: true)
        timer.tolerance = Double(interval) * 0.1 // perf gain by allowing fuzzy times.
    }



    
    func setTimeDisplay() {
        timeDisplay.text = String(Int(remaining) / 60)
        secDisplay.text = ":" + String(Int(remaining % 60))
        self.setNeedsDisplay()
    }
    

    // Every step of the timer calls this method
    func tick() {
        remaining = round(remaining)
        remaining -= interval
        if remaining <= 0 {
            // stop timer
            timeDisplay.text = ""
            secDisplay.text = ""
        } else {
            percentage = remaining / limit
            println(remaining)
            setTimeDisplay()
        }
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
