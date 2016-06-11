//
//  ViewController.swift
//  Finish It
//
//  Created by Micah Lanier on 4/14/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit
import pop
import AVFoundation
import SwifteriOS


private extension Selector {
    static let buttonTapped =
        #selector(HomeViewController.buttonTapped(_:))
}


class HomeViewController: UIViewController, FinishedQuoteViewProtocol, DismissProtocol, UITextFieldDelegate, getQuoteProtocol {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var quoteOfDayLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lineView: UIView!
    private var accessToken: String?
    private let consumerKey = "dIS3vBfYpu5a87L6zSLV0ab3f"
    private let consumerSecret = "joYbUyXHwdQOtBpc6ULOSfGMrCok6ytqpcraR3mGzHcXpuR939"
    private let baseUrlString = "https://api.twitter.com/1.1/"
    var quote = Quote(quoteText:"")
    var selectedQuote: String?
    var quoteSelected: Bool?
    var currentUser: User?
    var areButtonsFanned = false
    var dynamicAnimator: UIDynamicAnimator?
    var buttonOne: UIButton?
    var buttonTwo: UIButton?
    var tweets: Array<Tweet>?
    var swifter: Swifter?
    var clickSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Peak_Button1", ofType: "wav")!)
    var audioPlayer = AVAudioPlayer()
    @IBOutlet var finishedButton: FinishedButton!
    @IBOutlet weak var finishedQuoteView: FinishedQuoteView!
    @IBOutlet weak var blurView: BlurView!

    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var animationImageView: AnimationImageView!
    @IBOutlet weak var quoteLabelTopConstraint: NSLayoutConstraint!
    let limitLength = 45


    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        buttonOne = createButtonWithName("Quotes")
        buttonTwo = createButtonWithName("Web")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "EskapadeFraktur", size: 20.0)!,
                                                                         NSForegroundColorAttributeName: UIColor.whiteColor()]
        do {
            try  audioPlayer =  AVAudioPlayer(contentsOfURL: clickSound)
        } catch {
            print("Player not available")
        }

        audioPlayer.prepareToPlay()

        quoteOfDayLabel.alpha = 0
        characterLabel.alpha = 0
        headingLabel.alpha = 0
        quoteLabelTopConstraint.constant = -30
        lineView.alpha = 0
        textField.alpha = 0
        finishedButton.alpha = 0
        finishedQuoteView.alpha = 0
        finishedQuoteView.delegate = self
        blurView.delegate = self
        textField.delegate = self
        areButtonsFanned = false
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        buttonOne?.hidden = true
        buttonTwo?.hidden = true
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        eyeButton.addTarget(self, action: .buttonTapped, forControlEvents: .TouchUpInside)
        eyeButton.tag = 0
        buttonOne?.addTarget(self, action: .buttonTapped, forControlEvents: .TouchUpInside)
        buttonOne?.tag = 1
        buttonTwo?.addTarget(self, action: .buttonTapped, forControlEvents: .TouchUpInside)
        buttonTwo?.tag = 2
        characterLabel.text = "\(limitLength)"

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
                spring.toValue = 130

                if DeviceType.IS_IPHONE_5 {
                    spring.toValue = 115
                }
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

    func createButtonWithName(name: String) -> UIButton {
        let center = eyeButton.center
        //let rect = CGRectMake(eyeButton.frame.origin.x, eyeButton.frame.origin.y, 50, 50)
        let button = UIButton(frame: eyeButton.frame)
        button.center = center
        button.layer.borderWidth = 0.0
        button.setTitle(name, forState: .Normal)
        button.titleLabel!.font = UIFont(name: "EskapadeFraktur", size: 23)
        button.setTitleColor(UIColor(red: 150/255, green: 150/255, blue: 142/255, alpha: 1)
, forState: .Normal)
        button.sizeToFit()

        //button.setImage(UIImage(named: name), forState: .Normal)
        self.view.addSubview(button)
        return button
    }

    func fanButtons() {
        print("fan buttons")
        audioPlayer.play()

        dynamicAnimator?.removeAllBehaviors()

        if areButtonsFanned == true {
            fanIn()
            eyeButton.alpha = 1
        } else {
            fanOut()
            eyeButton.alpha = 0.4
        }
        areButtonsFanned = !areButtonsFanned
    }

    func fanIn() {
        buttonOne?.alpha = 1
        buttonTwo?.alpha = 1
        var snapBehavior: UISnapBehavior
        snapBehavior = UISnapBehavior(item: buttonOne!, snapToPoint: eyeButton.center)
        snapBehavior.damping = 1.0
        dynamicAnimator?.addBehavior(snapBehavior)

        snapBehavior = UISnapBehavior(item: buttonTwo!, snapToPoint: eyeButton.center)
        dynamicAnimator?.addBehavior(snapBehavior)
        UIView.animateWithDuration(0.2) { 
            self.buttonOne?.alpha = 0
            self.buttonTwo?.alpha = 0
        }

    }

    func fanOut() {
        buttonOne?.alpha = 0
        buttonTwo?.alpha = 0
        buttonOne?.hidden = false
        buttonTwo?.hidden = false

        UIView.animateWithDuration(0.2) {
            self.buttonOne?.alpha = 1
            self.buttonTwo?.alpha = 1
        }

        var point = CGPoint()
        var snapBehavior: UISnapBehavior

        point = CGPointMake(eyeButton.frame.origin.x - 75, eyeButton.frame.origin.y + 20)
        snapBehavior = UISnapBehavior(item: buttonOne!, snapToPoint: point)
        dynamicAnimator?.addBehavior(snapBehavior)

        point = CGPointMake(eyeButton.frame.origin.x + 115, eyeButton.frame.origin.y + 20)
        snapBehavior = UISnapBehavior(item: buttonTwo!, snapToPoint: point)
        dynamicAnimator?.addBehavior(snapBehavior)

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
                self.animationImageView.animate()
                self.resignFirstResponder()

                self.finishedQuoteView.hidden = false
                self.finishedQuoteView.alpha = 1
                self.finishedQuoteView.quote = self.quoteOfDayLabel.text!
                self.finishedQuoteView.enteredText = self.textField.text!

                let sentinelBook = UIFont(name: "Sentinel-Book", size: 17)
                let sentinelDict = NSDictionary(object: sentinelBook!, forKey: NSFontAttributeName)
                let aAttrString = NSMutableAttributedString(string: self.quoteOfDayLabel.text!, attributes: sentinelDict as? [String : AnyObject])

                let sentinelSemiBold = UIFont(name: "Sentinel-SemiBold", size: 17)
                let sentinelDict2 = NSDictionary(object: sentinelSemiBold!, forKey: NSFontAttributeName)
                let bAttrString = NSMutableAttributedString(string: " \(self.textField.text!)", attributes: sentinelDict2 as? [String : AnyObject])

                aAttrString.appendAttributedString(bAttrString)
                self.finishedQuoteView.configure(aAttrString)

//                self.finishedQuoteView.quoteLabel.text = "\(self.quoteOfDayLabel.text!) \(self.textField.text!)"
                let spring = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
                spring.toValue = NSValue(CGSize: CGSizeMake( 1.1, 1.1))
                spring.springBounciness = 10
                spring.springSpeed = 8
                self.finishedQuoteView.layer.pop_addAnimation(spring, forKey: "moveDown")
                if self.areButtonsFanned == true {
                    self.fanButtons()
                }
                UIView.animateWithDuration(0.5, animations: {
                    self.blurView.animate()
                    self.eyeButton.enabled = false
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
                self.eyeButton.enabled = true
        }

        UIView.animateWithDuration(0.3) {
            self.finishedButton.alpha = 1
        }
    }

    @IBAction func loadSelectedQuote(segue:UIStoryboardSegue) {

        quoteSelected = true
        headingLabel.alpha = 0
        textField.text = ""
        characterLabel.text = "\(limitLength)"

        if quoteSelected == true {
            UIView.animateWithDuration(1.0, animations: {
                self.quoteOfDayLabel.alpha = 1
                self.quoteOfDayLabel.text = self.selectedQuote
            })
        }
    }


    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        let length = limitLength - newLength
        characterLabel.text = "\(length)"
        return newLength <= limitLength
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.3) { 
            self.finishedButton.alpha = 0
            self.characterLabel.alpha = 1
        }
    }

    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("cleared")
        characterLabel.text = "\(limitLength)"
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        UIView.animateWithDuration(0.4) {
            self.finishedButton.alpha = 1
        }
        return false
    }


    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
        showButton()
    }

    func showButton() {
        UIView.animateWithDuration(0.4) {
            self.finishedButton.alpha = 1
            self.characterLabel.alpha = 0
        }
    }

    func buttonTapped(sender: UIButton) {
        if sender.tag == 0 {
            fanButtons()
        } else if sender.tag == 1 {
            showQuotes()
        } else if sender.tag == 2 {
            showTweets()
        }
    }

    func showQuotes() {
        print("show quotes")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let quotes = mainStoryboard.instantiateViewControllerWithIdentifier("ListVC") as! ListViewController
        quotes.delegate = self
        self.presentViewController(quotes, animated: true, completion: nil)
    }

    func showTweets() {
        print("show tweets")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let tweetVC = mainStoryboard.instantiateViewControllerWithIdentifier("TweetVC") as! TweetsViewController
        //tweetVC.tweets = self.tweets
        self.presentViewController(tweetVC, animated: true, completion: nil)

    }

    func selectedQuoteOfDay() {
        let quoteRequest = DataService.dataService.getQuote()
        let quote = Quote(quoteText: quoteRequest)
        quoteOfDayLabel.text = quote.quoteText
        headingLabel.alpha = 1


    }





}

