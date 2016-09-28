//
//  GradientNavBar.swift
//  Finish It
//
//  Created by Micah Lanier on 6/16/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit

@IBDesignable class GradientNavBar: UIView {

    var gradientLayer: CAGradientLayer!

    /// Top color of the gradient layer
    @IBInspectable var topColor: UIColor = UIColor.init(red: 49/255, green: 59/255, blue: 117/255, alpha: 0.8) {
        didSet {
            updateUI()
        }
    }

    /// Bottom color of the gradient layer
    @IBInspectable var bottomColor: UIColor = UIColor.clearColor() {
        didSet {
            updateUI()
        }
    }

    /// At which vertical point the layer should end
    @IBInspectable var bottomYPoint: CGFloat = 0.6 {
        didSet {
            updateUI()
        }
    }

    /**
     Initialises the view

     - parameter aDecoder: aDecoder

     - returns: self
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradientLayer()
    }

    /**
     Initialises the view

     - parameter frame: frame to use

     - returns: self
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    /**
     Sets up the gradient layer
     */
    func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [topColor.CGColor, bottomColor.CGColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: bottomYPoint)
        layer.addSublayer(gradientLayer)
    }

    /**
     Updates the UI
     */
    func updateUI() {
        setNeedsDisplay()
    }

    /**
     Adjusts the background of the view if user scrolls down enough

     - parameter isClear: YES, if the background needs to be clear, otherwise use a solid color
     */
    func adjustBackground(isClear: Bool) {
        if isClear == true {
            gradientLayer.hidden = false
            backgroundColor = UIColor.clearColor()
        } else {
            gradientLayer.hidden = true
            backgroundColor = UIColor(red: CGFloat(54/255.0), green: CGFloat(54/255.0), blue: CGFloat(54/255.0), alpha: 1.0)
        }
    }

    /**
     Lays out all the subviews it has, in our case the gradient layer
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = frame
    }

    /**
     Prepares UI for interface builder
     */
    override func prepareForInterfaceBuilder() {
        setupGradientLayer()
    }



}
