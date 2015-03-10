//
//  TimerViewController.swift
//  View controler for the physical timer based on a scroll view
//
//  Created by Eric on 3/8/15.
//  Copyright (c) 2015 Simple Guy. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView:  UIScrollView!
    @IBOutlet var timeDisplay: TimeDisplay!
    @IBOutlet var flashbulb: Flashbulb!
    
    var audioController = AudioController()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.delegate = self
        
        timeDisplay.onRing(onRing)
        audioController.flashbulb = flashbulb
    }
    
    
    func onRing() {
        println("TimerViewController.onRing()")
        audioController.play()
    }
    
    
    // scrollView event handling
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("scrollViewDidScroll")
        timeDisplay.set(scrollView: scrollView)
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        println("scrollViewWillBeginDragging")
        timeDisplay.stop()
    }
    
    func scrollViewWillEndDragging (scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let y = targetContentOffset.memory.y
        let tickSize:CGFloat = self.view.frame.height / 10
        
        // Determine which table cell the scrolling will stop on.
        var cellIndex = floor(y / tickSize);
        // Round to the next cell if the scrolling will stop over halfway to the next cell.
        if ((y - (floor(y / tickSize) * tickSize)) > tickSize) {
            cellIndex++;
        }
        // Adjust stopping point to exact beginning of cell.
        targetContentOffset.memory.y = cellIndex * tickSize;
        
        println("scrollViewWillEndDragging")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        println("scrollViewDidEndDragging")
        if !decelerate { // http://keighl.com/post/did-uiscrollview-end-scrolling/
            timeDisplay.start()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("scrollViewDidEndDecelerating")
        timeDisplay.start()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        println("scrollViewDidEndScrollingAnimation")
        timeDisplay.start()
    }
    

    // When the screen is tapped (not dragged), jump the scroll view to that location
    @IBAction func onTap(recognizer: UITapGestureRecognizer) {
        let y = recognizer.locationInView(self.view).y
        let offset = CGPoint(x:0, y: self.view.frame.height - y)
        println("onTap offset: \(offset)")
        timeDisplay.stop()
        scrollView.setContentOffset(offset, animated: true)

//        UIView.animateWithDuration(0.1, animations: {
//            self.scrollView.contentOffset = offset
//        })

    }
    
    

//    override func loadView() {
//        let w = UIScreen.mainScreen().applicationFrame.width
//        let h = UIScreen.mainScreen().applicationFrame.height + 20 // 20 for status bar
        
        // Create a scrollView that is as large as the screen
//        var scrollView = UIScrollView(frame: CGRectMake(0,0,w,h))
//        scrollView.contentSize = CGSizeMake(w, h * 2)
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.backgroundColor = UIColor.blackColor()
        
//        scrollView.pagingEnabled = true // allow left/right page swiping
        
//        [scrollView release];         // TODO: release scrollView as self.view retains it
        
        // Add a fill rectangle the height of the screen just off screen.
//        var rectView = UIView(frame: CGRectMake(0, h-1, w, h))
//        rectView.backgroundColor = scrollView.tintColor
//        scrollView.addSubview(rectView)
        
//        self.view = scrollView
//    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
}