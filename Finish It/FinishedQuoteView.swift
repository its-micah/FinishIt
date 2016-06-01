//
//  FinishedQuoteView.swift
//  Finish It
//
//  Created by Micah Lanier on 4/19/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit

protocol FinishedQuoteViewProtocol {
    func showSharingWithImageAndText(image: UIImage, text: String)
}

class FinishedQuoteView: UIView {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    var delegate : FinishedQuoteViewProtocol?

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func configure(quote: NSMutableAttributedString) {
        self.quoteLabel.attributedText = quote
    }
    
    @IBAction func onShareButtonTapped(sender: UIButton) {
        print("share")
//        UIGraphicsBeginImageContext(CGSizeMake(500, 500))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 500, height: 500), false, 0)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        // 2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Left

        // 3
//        let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSParagraphStyleAttributeName: paragraphStyle]

        // 4
        let string = self.quoteLabel.attributedText

        string?.drawWithRect(CGRect(x: 32, y: 32, width: 448, height: 448), options: .UsesLineFragmentOrigin, context: nil)

        // 5
        let mouse = UIImage(named: "eye")
        mouse?.drawAtPoint(CGPoint(x: 300, y: 150))

        // 6
        let img = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        // 7
        let TwitterText = "#ItIsFinishedApp"
        delegate?.showSharingWithImageAndText(img, text: TwitterText)


//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
//        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
//
//        let screenShot: UIImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        let TwitterText = "#FinishIt"
//        delegate?.showSharingWithImageAndText(screenShot, text: TwitterText)

    }

}
