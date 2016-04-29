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
    @IBOutlet weak var nameLabel: UILabel!
    var delegate : FinishedQuoteViewProtocol?

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func configure(quote: String, name: String, image: UIImage) {
        self.userImageView.image = image
        self.quoteLabel.text = quote
        self.nameLabel.text = name
    }
    
    @IBAction func onShareButtonTapped(sender: UIButton) {
        print("share")
        //UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height))
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
//        let context: CGContextRef = UIGraphicsGetCurrentContext()!
//        self.layer.renderInContext(context)
        let screenShot: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let TwitterText = "#FinishIt"
        delegate?.showSharingWithImageAndText(screenShot, text: TwitterText)
        
    }

}
