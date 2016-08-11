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

    func animateWithNameAndFrames(name: String, frames: Int) {
        print("animating view now")
        self.hidden = false

        if name == "savedLibAnimation" {
            if let soundURL = NSBundle.mainBundle().URLForResource("IIF-4", withExtension: "wav") {
                var mySound: SystemSoundID = 0
                AudioServicesCreateSystemSoundID(soundURL, &mySound)
                // Play
                AudioServicesPlaySystemSound(mySound);
            }
        }


        self.alpha = 1
        var imagesArray = [UIImage]()

        for var i = 0; i <= frames; i += 1 {
            let imageName = "\(name)_\(i).png"
            if let image = UIImage(named: imageName) {
                imagesArray.append(image)
            }
        }

        let duration = CFTimeInterval.init(frames)

        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "contents")
        animation.calculationMode = kCAAnimationDiscrete;
        animation.duration = duration / 24 // 24 frames per second
        animation.values = imagesArray.map {$0.CGImage as! AnyObject}
        animation.repeatCount = 1
        animation.delegate = self
        self.layer.addAnimation(animation, forKey: "animation")


    }

    func animateSparkles(name: String, frames: Int) {
        var imagesArray = [UIImage]()

        for var i = 0; i <= frames; i += 1 {
            let imageName = "\(name)_\(i).png"
            if let image = UIImage(named: imageName) {
                imagesArray.append(image)
            }
        }

        let duration = CFTimeInterval.init(frames)

        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "contents")
        animation.calculationMode = kCAAnimationDiscrete;
        animation.duration = duration / 24 // 24 frames per second
        animation.values = imagesArray.map {$0.CGImage as! AnyObject}
        animation.repeatCount = 1
        self.layer.addAnimation(animation, forKey: "animation")

    }


    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.delegate!.finishedAnimation()
        }
    }

}
