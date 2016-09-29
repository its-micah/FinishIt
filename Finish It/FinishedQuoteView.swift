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
    var quote: String? = nil
    var enteredText: String? = nil

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func configure(quote: NSMutableAttributedString) {
        quoteLabel.textColor = UIColor.blackColor()
        self.quoteLabel.attributedText = quote
    }
    
    @IBAction func onShareButtonTapped(sender: UIButton) {
        print("share")
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 500, height: 500), false, 0)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)

        let paragraphStyle = NSMutableParagraphStyle()
        let fontsize: CGFloat = 33

        let sentinelBook = UIFont(name: "Sentinel-Book", size: fontsize)
        let sentinelDict = NSDictionary(object: sentinelBook!, forKey: NSFontAttributeName)
        let aAttrString = NSMutableAttributedString(string: quote!, attributes: sentinelDict as? [String : AnyObject])

        let sentinelSemiBold = UIFont(name: "Sentinel-SemiBold", size: fontsize)
        let sentinelDict2 = NSDictionary(object: sentinelSemiBold!, forKey: NSFontAttributeName)
        let bAttrString = NSMutableAttributedString(string: " \(enteredText!)", attributes: sentinelDict2 as? [String : AnyObject])

        aAttrString.appendAttributedString(bAttrString)

        paragraphStyle.alignment = .Left

        let string = aAttrString
        let frame = CGRect(x: 0, y: 0, width: 450, height: 10)
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.attributedText = string
        label.sizeToFit()


        print(label.frame.height)


        string.drawWithRect(CGRect(x: 60, y: 200, width: 350, height: 180), options: .UsesLineFragmentOrigin, context: nil)

        let wizard = UIImage(named: "wizardTransparentSmall")
        print(wizard?.size)

        wizard?.drawAtPoint(CGPoint(x: 220, y: 75))


        let img = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        let TwitterText = "#ItIsFinishedApp"
        delegate?.showSharingWithImageAndText(img!, text: TwitterText)




    }

}


//let label = UILabel(frame: CGRectMake(labelX, labelY, 400, 100)) // The last variable, 21, is the label's height.  Change as you see fit.
// 3
//        let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSParagraphStyleAttributeName: paragraphStyle]

//label.attributedText = string
//self.addSubview(label)
