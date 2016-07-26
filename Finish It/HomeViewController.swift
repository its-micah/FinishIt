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


class HomeViewController: UIViewController, FinishedQuoteViewProtocol, DismissProtocol, UITextViewDelegate, getQuoteProtocol, Animatable {

    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var shareButton: FinishedButton!
    private var accessToken: String?
    private let consumerKey = "dIS3vBfYpu5a87L6zSLV0ab3f"
    private let consumerSecret = "joYbUyXHwdQOtBpc6ULOSfGMrCok6ytqpcraR3mGzHcXpuR939"
    private let baseUrlString = "https://api.twitter.com/1.1/"
    var quote = Quote(quoteText:"")
    var currentQuote: String?
    var quoteSelected: Bool?
    var currentUser: User?
    var areButtonsFanned = false
    var dynamicAnimator: UIDynamicAnimator?
    var buttonOne: UIButton?
    var buttonTwo: UIButton?
    var tweets: Array<Tweet>?
    var swifter: Swifter?
    var enteredText: String?
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

        characterLabel.alpha = 0
        textView.alpha = 0
        finishedButton.alpha = 0
        finishedQuoteView.alpha = 0
        finishedQuoteView.delegate = self
        blurView.delegate = self
        textView.delegate = self
        animationImageView.delegate = self
        areButtonsFanned = false
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        buttonOne?.hidden = true
        buttonTwo?.hidden = true
        shareButton.hidden = true
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        eyeButton.addTarget(self, action: .buttonTapped, forControlEvents: .TouchUpInside)
        eyeButton.tag = 0
        buttonOne?.addTarget(self, action: .buttonTapped, forControlEvents: .TouchUpInside)
        buttonOne?.tag = 1
        buttonTwo?.addTarget(self, action: .buttonTapped, forControlEvents: .TouchUpInside)
        buttonTwo?.tag = 2
        characterLabel.text = "\(limitLength)"

        addStuff()

    
    }

    func createButtonWithName(name: String) -> UIButton {
        let center = eyeButton.center
        //let rect = CGRectMake(eyeButton.frame.origin.x, eyeButton.frame.origin.y, 50, 50)
        let button = UIButton(frame: eyeButton.frame)
        button.center = center
        button.layer.borderWidth = 0.0
        button.setTitle(name, forState: .Normal)
        button.titleLabel!.font = UIFont(name: "EskapadeFraktur", size: 23)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        //button.setTitleColor(UIColor(red: 150/255, green: 150/255, blue: 142/255, alpha: 1)
//, forState: .Normal)
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
        if textView.text == currentQuote! || textView.text == currentQuote! + " " || textView.text == currentQuote! + " finish it" || textView.text == currentQuote! + ""{
            moveCursor()
            let alert  = UIAlertController(title: "WOAH NOW", message: "You didn't finish it. Get it together.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {

            sender.animateTouchUpInside {
                print("touched")
                self.animationImageView.animate()
                self.eyeButton.alpha = 0
                self.finishedButton.alpha = 0
                if self.areButtonsFanned == true {
                    self.fanButtons()
                }
                self.resignFirstResponder()

                let quoteText = self.buildQuoteWithFontSize(18)

                self.finishedQuoteView.configure(quoteText)



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
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            if success == true {
                self.dismiss()
            }
        }
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
            self.eyeButton.alpha = 1

            self.shareButton.alpha = 0
        }

    }

    @IBAction func loadSelectedQuote(segue:UIStoryboardSegue) {

        quoteSelected = true
        characterLabel.text = "\(limitLength)"
        let fontsize: CGFloat = 33
        let sentinelSemiBold = UIFont(name: "Sentinel-SemiBold", size: fontsize)
        let sentinelDict = NSDictionary(object: sentinelSemiBold!, forKey: NSFontAttributeName)
        let attrText = NSMutableAttributedString(string: currentQuote!, attributes: sentinelDict as? [String : AnyObject])
        let finishIt = addFinishItText()

        attrText.appendAttributedString(finishIt)

        if quoteSelected == true {
            self.textView.attributedText = attrText
//            self.moveCursor(self.textView)
            UIView.animateWithDuration(1.0, animations: {
                //self.quoteOfDayLabel.alpha = 1
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

    func addFinishItText() -> NSMutableAttributedString {
        let fontsize: CGFloat = 33
        let sentinelSemiBold = UIFont(name: "Sentinel-SemiBold", size: fontsize)
        let sentinelDict = NSDictionary(object: sentinelSemiBold!, forKey: NSFontAttributeName)
        let finishIt = NSMutableAttributedString(string: " finish it", attributes: sentinelDict as? [String : AnyObject])
        finishIt.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 166/255, green: 175/255, blue: 228/255, alpha: 1), range: NSRange(location: 0, length: finishIt.length))
        return finishIt
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
        self.presentViewController(tweetVC, animated: true, completion: nil)

    }

    func selectedQuoteOfDay() {

        let fontsize: CGFloat = 33

        let sentinelSemiBold = UIFont(name: "Sentinel-SemiBold", size: fontsize)
        let sentinelDict = NSDictionary(object: sentinelSemiBold!, forKey: NSFontAttributeName)
        let quoteRequest = DataService.dataService.getQuote()
        let quote = Quote(quoteText: quoteRequest)
        currentQuote = quote.quoteText
        let attrText = NSMutableAttributedString(string: currentQuote!, attributes: sentinelDict as? [String : AnyObject])
        let finishIt = addFinishItText()

        attrText.appendAttributedString(finishIt)

        self.textView.attributedText = attrText
    }

    func textViewDidBeginEditing(textView: UITextView) {
        self.performSelector(#selector(HomeViewController.moveCursor), withObject: textView, afterDelay: 0.0)
        //self.characterLabel.alpha = 1
    }

    func textViewDidEndEditing(textView: UITextView) {
        self.characterLabel.alpha = 0
    }

    func moveCursor() {
        let finishIt = addFinishItText()
        let length = textView.text.characters.count - finishIt.length
        textView.selectedRange = NSMakeRange(length, 0)
        let stringRange = textView.text.rangeOfString(finishIt.string)
        if textView.text.containsString("finish it") {
            textView.text.removeRange(stringRange!)
        }
        if let newPosition = textView.positionFromPosition(textView.beginningOfDocument, inDirection: UITextLayoutDirection.Right, offset: (currentQuote?.characters.count)!) {

            textView.text = currentQuote! + " "
        }
    }

    func isAcceptableTextLength(length: Int) -> Bool {
        return length <= limitLength
    }


    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        guard let text2 = textView.text else { return true }

        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        

        let newLength = text2.characters.count
        let length = limitLength - newLength
        characterLabel.text = "\(length)"
        print(length)
        if let quoteLength = currentQuote?.characters.count {

            if isAcceptableTextLength(textView.text.characters.count - quoteLength) {

                if range.location >= quoteLength {
                    let attrString = NSMutableAttributedString(string: textView.text)
                    let sentinelSemiBold = UIFont(name: "Sentinel-SemiBold", size: 33)

                    attrString.addAttribute(NSFontAttributeName, value: sentinelSemiBold!, range: NSRange(location: 0, length: textView.text.characters.count))
                        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location:quoteLength,length:textView.text.characters.count - quoteLength))

                    textView.attributedText = attrString
                    
                    return true

                }
            }
        }

        return false



    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func onShareButtonTapped(sender: FinishedButton) {

        sender.animateTouchUpInside { 
            print("share")
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 500, height: 281), false, 0)
            let context: CGContextRef = UIGraphicsGetCurrentContext()!
            CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)

            let quoteText = self.buildQuoteWithFontSize(33)

            let frame = CGRect(x: 0, y: 0, width: 450, height: 10)
            let label = UILabel(frame: frame)
            label.numberOfLines = 0
            label.attributedText = quoteText
            label.sizeToFit()


            print(label.frame.height)


            quoteText.drawWithRect(CGRect(x: 60, y: 95, width: 350, height: 180), options: .UsesLineFragmentOrigin, context: nil)

            let wizard = UIImage(named: "wizardTransparentSmall")
            print(wizard?.size)

            wizard?.drawAtPoint(CGPoint(x: 430, y: 210))
            
            
            let img = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            let TwitterText = "#ItIsFinishedApp"
            self.showSharingWithImageAndText(img, text: TwitterText)
        }

        
    }

    func buildQuoteWithFontSize(fontsize: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        let startIndex = self.textView.text.startIndex.advancedBy((self.currentQuote?.characters.count)!)
        let rangeOfQuote = Range(start: startIndex, end: self.textView.text.characters.endIndex)
        self.enteredText = self.textView.text.substringWithRange(rangeOfQuote)
        print(self.enteredText)

        let sentinelBook = UIFont(name: "Sentinel-Book", size: fontsize)
        let sentinelDict = NSDictionary(object: sentinelBook!, forKey: NSFontAttributeName)
        let aAttrString = NSMutableAttributedString(string: self.currentQuote!, attributes: sentinelDict as? [String : AnyObject])

        let sentinelSemiBold = UIFont(name: "Sentinel-SemiBold", size: fontsize)
        let sentinelDict2 = NSDictionary(object: sentinelSemiBold!, forKey: NSFontAttributeName)
        let bAttrString = NSMutableAttributedString(string: self.enteredText!
            , attributes: sentinelDict2 as? [String : AnyObject])

        aAttrString.appendAttributedString(bAttrString)

        paragraphStyle.alignment = .Left

        let string = aAttrString

        return string

    }

    func finishedAnimation() {
        self.shareButton.alpha = 0
        self.finishedQuoteView.hidden = false
        self.shareButton.hidden = false
        self.finishedQuoteView.alpha = 1
        self.blurView.animate()

        self.eyeButton.enabled = false
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: {

            let spring = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            spring.toValue = NSValue(CGSize: CGSizeMake( 1.1, 1.1))
            spring.springBounciness = 10
            spring.springSpeed = 8
            self.finishedQuoteView.layer.pop_addAnimation(spring, forKey: "moveDown")

            UIView.animateWithDuration(0.4, animations: { 
                self.shareButton.alpha = 1
            })



            }, completion: nil)


    }

    func addStuff() {
        if quoteSelected == false || quoteSelected == nil {

            let fontsize: CGFloat = 33

            let sentinelSemiBold = UIFont(name: "Sentinel-SemiBold", size: fontsize)
            let sentinelDict = NSDictionary(object: sentinelSemiBold!, forKey: NSFontAttributeName)


            textView.alpha = 0
            let quoteRequest = DataService.dataService.getQuote()
            let quote = Quote(quoteText: quoteRequest)
            currentQuote = quote.quoteText
            let attrText = NSMutableAttributedString(string: currentQuote!, attributes: sentinelDict as? [String : AnyObject])
            let finishIt = addFinishItText()

            attrText.appendAttributedString(finishIt)

            self.textView.attributedText = attrText

            UIView.animateWithDuration(1.0, animations: {
                self.textView.alpha = 1
            })


            UIView.animateWithDuration(1, delay: 1, options: .CurveEaseInOut, animations: {
                self.finishedButton.alpha = 1
            }, completion: nil)
            
        }

    }






}

