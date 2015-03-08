//
//  TimerViewController.swift
//  View controler for the physical timer based on a scroll view
//
//  Created by Eric on 3/8/15.
//  Copyright (c) 2015 Simple Guy. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        let w = UIScreen.mainScreen().applicationFrame.width
        let h = UIScreen.mainScreen().applicationFrame.height + 20 // 20 for status bar
        
        // Create a scrollView that is as large as the screen
        var scrollView = UIScrollView(frame: CGRectMake(0,0,w,h))
        scrollView.contentSize = CGSizeMake(w, h * 2)
        scrollView.showsVerticalScrollIndicator = false

        
//        scrollView.pagingEnabled = true // allow left/right page swiping
        
        // do any further configuration to the scroll view
        // add a view, or views, as a subview of the scroll view.
        
        
//        [scrollView release];         // TODO: release scrollView as self.view retains it
        
        // Make two rectangles, both the width and height of the screen, stacked on top of each other
        // The top rectangle doesn't seem necessary, but without it the scroll view won't detect touches
        var rectView = UIView(frame: CGRectMake(0, 0, w, h))
        rectView.backgroundColor = UIColor.darkGrayColor()
        scrollView.addSubview(rectView)
        rectView = UIView(frame: CGRectMake(0, h, w, h))
        rectView.backgroundColor = scrollView.tintColor
//        rectView.backgroundColor = self.view.tintColor
        scrollView.addSubview(rectView)
        
        self.view = scrollView
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
}