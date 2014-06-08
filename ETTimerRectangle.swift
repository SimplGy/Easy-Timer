//
//  ETTimer.swift
//  Easy Timer
//
//  Created by Eric on 6/8/14.
//  Copyright (c) 2014 Simple Guy. All rights reserved.
//

import UIKit

class ETTimer: UIView {
    
    // The default boilerplate has a useless signature for init. bug? TODO: something I don't understand.
    //    init(frame: CGRect) {
    //        super.init(frame: frame)
    //        // Initialization code
    //
    //        println("custom view")
    //    }
    
    
    var timerPercentage:Float = 0.2
    let totalMinutes = 60.0 // a 60 minute timer
    
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder) // this sounds like a superhero ring. TODO: huh?
        println("In ETTimerRectangle")
    }
    
    // Given a Y offset, set the height of the timer rectangle.
    // The timer rectangle fills up the screen from the bottom.
    func setTimer(yOffset: Float) {
        let height = self.frame.height
        let distFromBottom = height - yOffset
        let ratio = distFromBottom / height
        self.alpha = ratio + 0.5
        timerPercentage = ratio
        println("Tapped: \(distFromBottom) from the bottom. Height is \(height), so it's \(timerPercentage*100)% full.")
        self.setNeedsDisplay()
    }
    
    @IBAction func onDrag(recognizer: UIPanGestureRecognizer) {
        let y = recognizer.locationInView(self).y
        setTimer(y)
    }
    
    @IBAction func onTap(recognizer: UITapGestureRecognizer) {
        setTimer(recognizer.locationInView(self).y)
    }

    // override drawRect if you perform custom drawing.
    override func drawRect(var rect: CGRect)
    {
        var percentage = timerPercentage
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
