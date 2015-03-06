//
//  Flashbulb.swift
//  Displays a flashing light effect
//
//  Created by Eric on 3/6/15.
//  Copyright (c) 2015 Simple Guy. All rights reserved.
//

import UIKit


class Flashbulb: UIView {
    
    let off = UIColor.clearColor().CGColor
    let on  = UIColor.whiteColor().CGColor
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Fire the bulb: Visually flash
    func fire(){
        println("flashbulb.fire()")
//        let animation = CABasicAnimation(keyPath: "backgroundColor")
        let animation = CAKeyframeAnimation(keyPath: "backgroundColor")

        animation.values = [ off, on, off ]
        animation.keyTimes = [ 0, 0.5, 1 ]
        animation.duration = 0.3
        animation.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut as String),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn as String)
        ]
        animation.repeatDuration = 3
        self.layer.addAnimation(animation, forKey: "flashBg")
        
//        UIView.animateWithDuration(1, delay: 0, options: animationOptions, animations: {
//            self.alpha = 0
//            }, completion: { (isFinished) in
//            println("animation finished")
//        })
    }

}