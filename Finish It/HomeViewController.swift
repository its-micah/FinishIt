//
//  ViewController.swift
//  Finish It
//
//  Created by Micah Lanier on 4/14/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit
import Firebase
import pop

class ViewController: UIViewController, FinishedQuoteViewProtocol, DismissProtocol {

    @IBOutlet weak var quoteOfDayLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var quotesButton: UIButton!
    let ref = Firebase(url: "https://finishit.firebaseIO.com")
    var quote = Quote(quoteText:"")
    var selectedQuote: String?
    var quoteSelected: Bool?
    var user: User?
    @IBOutlet var finishedButton: FinishedButton!
    @IBOutlet weak var finishedQuoteView: FinishedQuoteView!
    @IBOutlet weak var blurView: BlurView!

    @IBOutlet weak var quoteLabelTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        quoteLabelTopConstraint.constant = -30
        lineView.alpha = 0
        textField.alpha = 0
        finishedButton.alpha = 0
        finishedQuoteView.alpha = 0
        finishedQuoteView.delegate = self
        blurView.delegate = self

    }

    override func viewDidAppear(animated: Bool) {

        if quoteSelected == false || quoteSelected == nil {
            quoteOfDayLabel.alpha = 0
            let quoteRequest = DataService.dataService.getQuote()
            let quote = Quote(quoteText: quoteRequest)

                UIView.animateWithDuration(1.0, animations: {
                    self.quoteOfDayLabel.alpha = 1
                    self.quoteOfDayLabel.text = quote.quoteText
                })

                    let spring = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                    spring.toValue = 100
                    spring.springBounciness = 20
                    spring.springSpeed = 2
                    spring.beginTime = (CACurrentMediaTime() + 1)
                    self.quoteLabelTopConstraint.pop_addAnimation(spring, forKey: "moveDown")
                
                UIView.animateWithDuration(1, delay: 2, options: .CurveEaseInOut, animations: {
                    self.lineView.alpha = 1
                    self.textField.alpha = 1
                    self.finishedButton.alpha = 1
                }, completion: nil)
            
        }

    }
    
    
    @IBAction func onFinishedButtonTapped(sender: FinishedButton) {
        sender.animateTouchUpInside { 
            print("touched")
            self.resignFirstResponder()
            self.finishedQuoteView.hidden = false
            self.finishedQuoteView.alpha = 1
            //self.finishedQuoteView.configure("\(self.quoteOfDayLabel.text!) \(self.textField.text!)", name: , image: <#T##UIImage#>)
            
            let spring = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            spring.toValue = NSValue(CGSize: CGSizeMake( 1.1, 1.1))
            spring.springBounciness = 10
            spring.springSpeed = 8
            self.finishedQuoteView.layer.pop_addAnimation(spring, forKey: "moveDown")
            UIView.animateWithDuration(0.5, animations: {
                self.blurView.animate()
                self.quotesButton.enabled = false
            })
            
        }
    }
    
    func showSharingWithImageAndText(image: UIImage, text: String) {
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [text, image],
            applicationActivities: nil)
        let presentationController = activityViewController.popoverPresentationController
        presentationController?.sourceView = self.view
        presentationController?.sourceRect = CGRect(
            origin: CGPointZero,
            size: CGSize(width: self.view.frame.width / 1.2, height: self.view.frame.height / 1.2))
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        let spring = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        spring.toValue = NSValue(CGSize: CGSizeMake( 0.5, 0.5))
        spring.springBounciness = 10
        spring.springSpeed = 8
        finishedQuoteView.layer.pop_addAnimation(spring, forKey: "scaleDown")
        UIView.animateWithDuration(0.5) { 
            self.blurView.alpha = 0
        }
        UIView.animateWithDuration(0.4, animations: { 
            self.finishedQuoteView.alpha = 0
            }) { (true) in
                self.quotesButton.enabled = true
        }
    }

    @IBAction func loadSelectedQuote(segue:UIStoryboardSegue) {

        quoteSelected = true

        if quoteSelected == true {
            UIView.animateWithDuration(1.0, animations: {
                self.quoteOfDayLabel.alpha = 1
                self.quoteOfDayLabel.text = self.selectedQuote
            })

            let spring = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            spring.toValue = 100
            spring.springBounciness = 20
            spring.springSpeed = 2
            spring.beginTime = (CACurrentMediaTime() + 1)
            self.quoteLabelTopConstraint.pop_addAnimation(spring, forKey: "moveDown")

            UIView.animateWithDuration(1, delay: 2, options: .CurveEaseInOut, animations: {
                self.lineView.alpha = 1
                self.textField.alpha = 1
                self.finishedButton.alpha = 1
                }, completion: nil)
            }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
