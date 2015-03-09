//
//  TimeDisplayView.swift
//  Easy Timer
//
//  Created by Eric on 3/9/15.
//  Copyright (c) 2015 Simple Guy. All rights reserved.
//


import UIKit


class TimeDisplay: UIView {

    
    @IBOutlet var minutes: UILabel!
    @IBOutlet var seconds: UILabel!
    
    let limit: CGFloat         = 60.0 * 60.0    // What's the maximum amount of time you can set a timer for?
    let tickAmount: CGFloat    = 1.0            // 1.0 means: one tick per second
    let timerInterval: CGFloat = 1.0 / 60       // Should match `tickAmount`. Smaller values are for debugging.
    var percentage: CGFloat    = 0.0            // How much time is left, as a percentage of `limit`
    var remaining: CGFloat     = 0.0            // How much time is remaining right now?
//    var prevRemaining: CGFloat = 0.0            // On the last tick, how much time was remaining?
//    var setTime: CGFloat       = 0.0            // How much time has the user asked for a timer to run?
    var running: Bool          = false          // Is the timer running right meow?
    var scrollView: UIScrollView!               // Gets set as soon as someone sets a timer
    var onRingCallback: (()->())!               // an optional function reference
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var timer = NSTimer.scheduledTimerWithTimeInterval(
            NSTimeInterval(timerInterval),
            target: self,
            selector: "tick",
            userInfo: nil,
            repeats: true)
        timer.tolerance = Double(timerInterval) * 0.1 // perf gain by allowing fuzzy times.
    }



    // -------------------------------------------------- Public API
    
    // Set a new remaining time value for the timer
    // Don't start the timer yet
    // requires a scrollView so it can calculate the time based on contentOffset
    func set(scrollView s: UIScrollView){
        if scrollView == nil { scrollView = s } // only set it the first time
//        println("--- setTimer(). contentOffset.y: \(scrollView.contentOffset.y)")
        // Calculate the percentage and time remaining
        percentage = scrollView.contentOffset.y / scrollView.frame.height
        remaining = percentage * limit
//        println((percentage, remaining))
        updateTimeDisplay()
    }
    func start() {
        running = true
        // TODO: on start, flash/animate/bump the numbers to show something happened
    }
    func stop() {
        running = false
        remaining = 0.0
    }
    
    // Runs every tick, whether the timer is running or not
    func tick() {
        if (!running){ return }
//        println("tick")
        if remaining > 0 {                          // Timer is running
            remaining = round(remaining) - tickAmount
            percentage = remaining / limit
            updateDisplay() // moving the scroll view fires the event again which displays the time
        } else {                                    // Timer has *just* reached zero or slightly below
            println("just reached zero")
            ringTimer()
        }
    }
    
    // Set up a callback for when the timer rings
    func onRing(callback: ()->()) {
        onRingCallback = callback
    }
    
    
    
    // --------------------------------------------------- Private Methods
    // Update the display of numeric time and the visual percentage bar
    // Requires `remaining` to have been calculated
    private func updateDisplay() {
        updateTimeDisplay()
        updateScrollView()
    }
    private func updateTimeDisplay() {
        minutes.text = String(Int(remaining) / 60)
        var s = String(Int(remaining % 60))
        if countElements(s) == 1 {
            s = "0" + s
        }
        seconds.text = s
    }
    // Manipulate the scrollView to show the current remaining time percentage
    private func updateScrollView() {
        let offset = percentage * scrollView.frame.height
        scrollView.setContentOffset(CGPoint(x:0, y:offset), animated: false)
    }
    // Do anything that means the timer has rung
    private func ringTimer() {
        println("ringTimer()")
        stop()
//            updateDisplay()
        if onRingCallback != nil {
            onRingCallback()
        }
    }
    

    

}