//
//  BlurView.swift
//  Finish It
//
//  Created by Micah Lanier on 4/19/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit

protocol DismissProtocol {
    func dismiss()
}

class BlurView: UIView, UIGestureRecognizerDelegate {
    
    var delegate: DismissProtocol?

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    
    func commonInit() {
        self.alpha = 0
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(blurEffectView)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector(handleTap()))
        tap.delegate = self
        self.addGestureRecognizer(tap)

    }
    
    func animate() {
        self.alpha = 1
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.delegate?.dismiss()
    }

}
