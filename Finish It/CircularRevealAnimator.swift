//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//


import QuartzCore

private func SquareAroundCircle(center: CGPoint, radius: CGFloat) -> CGRect {
    assert(0 <= radius, "radius must be a positive value")
    return CGRect(origin: center, size: CGSize.zero).insetBy(dx: -radius, dy: -radius)
}

class CircularRevealAnimator {

    var completion: (() -> Void)?

    let layer: CALayer
    let mask: CAShapeLayer
    let animation: CABasicAnimation

    var duration: CFTimeInterval {
        get { return animation.duration }
        set(value) { animation.duration = value }
    }

    var timingFunction: CAMediaTimingFunction! {
        get { return animation.timingFunction }
        set(value) { animation.timingFunction = value }
    }

    init(layer: CALayer, center: CGPoint, startRadius: CGFloat, endRadius: CGFloat, invert: Bool = false) {
//        let startCirclePath = CGPath(ellipseIn: SquareAroundCircle(center, radius: startRadius), transform: nil)
//        let endCirclePath = CGPath(ellipseIn: SquareAroundCircle(center, radius: endRadius), transform: nil)

        let startCirclePath = CGPathCreateWithEllipseInRect(SquareAroundCircle(center, radius: startRadius), nil)
        let endCirclePath = CGPathCreateWithEllipseInRect(SquareAroundCircle(center, radius: endRadius), nil)



        let startPath = startCirclePath, endPath = endCirclePath
//        if invert {
//            var path = CGMutablePath()
//            path.addRect(layer.bounds)
//            path.addPath(startCirclePath)
//            startPath = path
//            path = CGMutablePath()
//            path.addRect(layer.bounds)
//            path.addPath(endCirclePath)
//            endPath = path
//        }

        self.layer = layer

        mask = CAShapeLayer()
        mask.path = endPath
        mask.fillRule = kCAFillRuleEvenOdd

        animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.delegate = AnimationDelegate {
            layer.mask = nil
            self.completion?()
            self.animation.delegate = nil
        }
    }

    func start() {
        layer.mask = mask
        mask.frame = layer.bounds
        mask.addAnimation(animation, forKey: "reveal")
    }
}
