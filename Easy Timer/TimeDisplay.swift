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
    
    let limit: CGFloat            = 60 * 10    // Max time limit in seconds
    let tickAmount: CGFloat       = 1          // One tick per second
    let speedMutliplier: CGFloat  = 1          // Speed multiplier for debugging
    var percentage: CGFloat       = 0          // How much time is left, as a percentage of `limit`
    var remainingSeconds: CGFloat = 0          // How many seconds are remaining right now?
    var userSetTime: CGFloat      = 0          // How much time has the user asked for a timer to run?
    var ticking: Bool            = false        // Is the timer running right meow?
    var scrollView: UIScrollView!             // Gets set as soon as someone sets a timer
    var onRingCallback: (()->())!             // an optional function reference
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var timer = NSTimer.scheduledTimerWithTimeInterval(
            NSTimeInterval(tickAmount / speedMutliplier),
            target: self,
            selector: "tick",
            userInfo: nil,
            repeats: true)
        timer.tolerance = Double(tickAmount) * 0.1 // perf gain by allowing fuzzy times.
    }



    // -------------------------------------------------- Public API
    
    // Set a new remaining time value for the timer
    // Don't start the timer yet
    // requires a scrollView so it can calculate the time based on contentOffset
    func set(scrollView s: UIScrollView){
        if scrollView == nil { scrollView = s } // only set it the first time
        println("--- setTimer(). contentOffset.y: \(scrollView.contentOffset.y)")
        measureSpace()
        // Calculate the percentage and time remaining
        percentage = scrollView.contentOffset.y / scrollView.frame.height
        remainingSeconds = percentage * limit
//        println((remaining, percentage))
        updateTimeDisplay()
    }
    func start() {
        ticking = true
        // TODO: on start, flash/animate/bump the numbers to show something happened
    }
    func stop() {
        ticking = false
    }
    
    // Runs every tick, whether the timer is running or not
    func tick() {
        if (!ticking){ return }
        remainingSeconds -= tickAmount
        if remainingSeconds < 0 { remainingSeconds = 0 }
        percentage = remainingSeconds / limit
        updateDisplay()
        if remainingSeconds <= 0 {                         // Timer has *just* reached zero or slightly below
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
//        println("updateTimeDisplay: \((m, s))")
        minutes.text = getMinutes(remainingSeconds)
        seconds.text = getSeconds(remainingSeconds)
    }
    
    // Manipulate the scrollView to show the current remaining time percentage
    // This is done "silently": http://stackoverflow.com/a/9418625/111243
    // Using the normal setContentOffset we get a loop because timer changes scrollview whose event changes timer.
    private func updateScrollView() {
        if (scrollView == nil) { return }
        let offset = percentage * scrollView.frame.height
        scrollView.bounds.origin = CGPoint(x:0, y:offset);
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
    
    // Convenience getters for the string versions of minutes and seconds.
    private func getSeconds(seconds: CGFloat) -> String {
        let s = Int( seconds % 60 )
        return s > 9 ? String(s) : "0" + String(s) // leading zero
    }
    private func getMinutes(seconds: CGFloat) -> String {
        let m = Int((seconds / 60) % 60)
        return String(m)
    }
    
    // Check that the physical space of the scroll view converts to nice round timings
    private func measureSpace() {
        let h = scrollView.frame.height
        var range: [CGFloat] = []
        
        range.append(0.0*h / h * limit)
        range.append(0.5*h / h * limit)
        range.append(1.0*h / h * limit)
        
        println("time range in this space: \(range)")
        
        percentage = scrollView.contentOffset.y / scrollView.frame.height
        let time = percentage * limit
        println("current time is \(time) at percentage \(percentage)")
        
    }
    

    

}