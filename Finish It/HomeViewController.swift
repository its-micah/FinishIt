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
import AVFoundation

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class HomeViewController: UIViewController, FinishedQuoteViewProtocol, DismissProtocol, UITextFieldDelegate {

    @IBOutlet weak var headingLabel: UILabel!
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

    @IBOutlet weak var animationImageView: UIImageView!
    @IBOutlet weak var quoteLabelTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        quoteOfDayLabel.alpha = 0
        headingLabel.alpha = 0
        quoteLabelTopConstraint.constant = -30
        lineView.alpha = 0
        textField.alpha = 0
        finishedButton.alpha = 0
        finishedQuoteView.alpha = 0
        finishedQuoteView.delegate = self
        blurView.delegate = self
        textField.delegate = self


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

            UIView.animateWithDuration(1.0, delay: 2, options: .CurveEaseInOut, animations: {
                self.headingLabel.alpha = 1
                }, completion: nil)


                    let spring = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                    spring.toValue = 100
                spring.toValue = 150

//                if DeviceType.IS_IPHONE_5 {
//                    spring.toValue = 115
//                }
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
        if textField.text == "" {
            let alert  = UIAlertController(title: "WOAH NOW", message: "You didn't finish it. Get it together for God's sake.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {



            sender.animateTouchUpInside {
                print("touched")
                self.animateSavedLibView()
                self.resignFirstResponder()
                self.finishedQuoteView.hidden = false
                self.finishedQuoteView.alpha = 1
                self.finishedQuoteView.quoteLabel.text = "\(self.quoteOfDayLabel.text!) \(self.textField.text!)"
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
        headingLabel.alpha = 0
        textField.text = ""

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

    func animateSavedLibView() {
        print("animating view now")
        animationImageView.hidden = false

        if let soundURL = NSBundle.mainBundle().URLForResource("thunder", withExtension: "mp3") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL, &mySound)
            // Play
            AudioServicesPlaySystemSound(mySound);
        }


        animationImageView.alpha = 1
        var imagesArray = [UIImage]()
        for name in ["savedLibAnimation_0.png", "savedLibAnimation_1.png", "savedLibAnimation_2.png", "savedLibAnimation_3.png", "savedLibAnimation_4.png", "savedLibAnimation_5.png", "savedLibAnimation_6.png", "savedLibAnimation_7.png", "savedLibAnimation_8.png", "csavedLibAnimation_9.png","savedLibAnimation_10.png", "savedLibAnimation_11.png", "savedLibAnimation_12.png", "savedLibAnimation_13.png", "savedLibAnimation_14.png", "savedLibAnimation_15.png", "savedLibAnimation_16.png", "savedLibAnimation_17.png", "savedLibAnimation_18.png", "savedLibAnimation_19.png", "csavedLibAnimation_20.png", "savedLibAnimation_21.png", "savedLibAnimation_22.png", "savedLibAnimation_23.png", "savedLibAnimation_24.png", "savedLibAnimation_25.png", "savedLibAnimation_26.png", "savedLibAnimation_27.png", "savedLibAnimation_28.png", "savedLibAnimation_29.png", "savedLibAnimation_30.png"] {
            if let image = UIImage(named: name) {
                imagesArray.append(image)
            }
        }

        animationImageView.animationImages = imagesArray
        animationImageView.animationDuration = 0.8
        animationImageView.animationRepeatCount = 1
        animationImageView.startAnimating()


    }

    func textFieldDidEndEditing(textField: UITextField) {
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

