//
//  AnimationImageView.swift
//  Finish It
//
//  Created by Micah Lanier on 6/9/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit
import AVFoundation

protocol Animatable {
    func finishedAnimation()
}

class AnimationImageView: UIImageView {

    var delegate : Animatable?


    func animate() {
        print("animating view now")
        self.hidden = false

        if let soundURL = NSBundle.mainBundle().URLForResource("Abstract_Hit_02", withExtension: "wav") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL, &mySound)
            // Play
            AudioServicesPlaySystemSound(mySound);
        }


        self.alpha = 1
        var imagesArray = [UIImage]()
        for name in ["savedLibAnimation_0.png", "savedLibAnimation_1.png", "savedLibAnimation_2.png", "savedLibAnimation_3.png", "savedLibAnimation_4.png", "savedLibAnimation_5.png", "savedLibAnimation_6.png", "savedLibAnimation_7.png", "savedLibAnimation_8.png", "csavedLibAnimation_9.png","savedLibAnimation_10.png", "savedLibAnimation_11.png", "savedLibAnimation_12.png", "savedLibAnimation_13.png", "savedLibAnimation_14.png", "savedLibAnimation_15.png", "savedLibAnimation_16.png", "savedLibAnimation_17.png", "savedLibAnimation_18.png", "savedLibAnimation_19.png", "csavedLibAnimation_20.png", "savedLibAnimation_21.png", "savedLibAnimation_22.png", "savedLibAnimation_23.png", "savedLibAnimation_24.png", "savedLibAnimation_25.png", "savedLibAnimation_26.png", "savedLibAnimation_27.png", "savedLibAnimation_28.png", "savedLibAnimation_29.png", "savedLibAnimation_30.png", "savedLibAnimation_31.png", "savedLibAnimation_32.png", "savedLibAnimation_33.png", "savedLibAnimation_34.png", "savedLibAnimation_35.png", "savedLibAnimation_36.png", "savedLibAnimation_37.png", "savedLibAnimation_38.png", "savedLibAnimation_39.png", "savedLibAnimation_40.png", "savedLibAnimation_41.png", "savedLibAnimation_42.png", "savedLibAnimation_43.png", "savedLibAnimation_44.png", "savedLibAnimation_45.png", "savedLibAnimation_46.png"] {
            if let image = UIImage(named: name) {
                imagesArray.append(image)
            }
        }


        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "contents")
        animation.calculationMode = kCAAnimationDiscrete;
        animation.duration = 47 / 24 // 30 frames per second
        animation.values = imagesArray.map {$0.CGImage as! AnyObject}
        animation.repeatCount = 1;
        animation.delegate = self;
        self.layer.addAnimation(animation, forKey: "animation")


    }

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.delegate!.finishedAnimation()
        }
    }

}
