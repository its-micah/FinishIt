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
import BubbleTransition


private extension Selector {
    static let buttonTapped =
        #selector(HomeViewController.buttonTapped(_:))
    static let keyboardWillShow = #selector(HomeViewController.keyboardWillShow(_:))
}


class HomeViewController: UIViewController, FinishedQuoteViewProtocol, DismissProtocol, UITextViewDelegate, getQuoteProtocol, Animatable, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var shareButton: FinishedButton!
    private var accessToken: String?
    private let consumerKey = "dIS3vBfYpu5a87L6zSLV0ab3f"
    private let consumerSecret = "joYbUyXHwdQOtBpc6ULOSfGMrCok6ytqpcraR3mGzHcXpuR939"
    private let baseUrlString = "https://api.twitter.com/1.1/"
    let transition = BubbleTransition()
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
    var keyboardHeight: CGFloat = 0
    var imagesArray = [UIImage]()
    var finishItSuffix = " tap to finish it"


    @IBOutlet var finishedButton: FinishedButton!
    @IBOutlet weak var finishedQuoteView: FinishedQuoteView!
    @IBOutlet weak var blurView: BlurView!

    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var animationImageView: AnimationImageView!
    @IBOutlet weak var quoteLabelTopConstraint: NSLayoutConstraint!
    let limitLength = 40


    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().statusBarStyle = .LightContent
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .keyboardWillShow, name: UIKeyboardWillShowNotification, object: nil)

        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        buttonOne = createButtonWithName("List")
        buttonTwo = createButtonWithName("Tweets")
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "EskapadeFraktur", size: 20.0)!,
                                                                         NSForegroundColorAttributeName: UIColor.whiteColor()]

        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL:clickSound)
            audioPlayer.prepareToPlay()
        }catch {
            print("Error getting the audio file")
        }

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

        eyeButton.setImage(UIImage(named: "whiteEyeball"), forState: .Normal)
        eyeButton.setImage(UIImage(named: "close"), forState: .Selected)


        UIApplication.sharedApplication().statusBarStyle = .LightContent
        eyeButton.addTarget(self, action: .buttonTapped, forControlEvents: .TouchUpInside)
        eyeButton.tag = 0
        buttonOne?.addTarget(self, action: .buttonTapped, forControlEvents: .TouchUpInside)
        buttonOne?.tag = 1
        buttonTwo?.addTarget(self, action: .buttonTapped, forControlEvents: .TouchUpInside)
        buttonTwo?.tag = 2
        characterLabel.text = "\(limitLength)"

        loadTextView()
        createBodyEditor()
        let frame = self.view.frame
        let sparkleView = AnimationImageView(frame: frame)
        self.view.addSubview(sparkleView)


//        for var i = 0; i <= 48; i += 1 {
//            let imageName = "eyeball_\(i).png"
//            if let image = UIImage(named: imageName) {
//                imagesArray.append(image)
//            }
//        }

        for i in 0...48 {
            let imageName = "eyeball_\(i).png"
            if let image = UIImage(named: imageName) {
                imagesArray.append(image)
            }
        }


        eyeButton.imageView?.animationImages = imagesArray
        eyeButton.setImage(imagesArray[0], forState: .Normal)

        NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: #selector(HomeViewController.animateEyeball), userInfo: nil, repeats: true)


    }

    override func viewDidAppear(animated: Bool) {

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
        
        if eyeButton.selected {
            eyeButton.selected = false
        } else {
            eyeButton.selected = true
        }
        print("fan buttons")

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
        audioPlayer.play()
        buttonOne?.alpha = 0
        buttonTwo?.alpha = 0
        buttonOne?.hidden = false
        buttonTwo?.hidden = false

        UIView.animateWithDuration(0.2) {
            self.buttonOne?.alpha = 1
            self.buttonTwo?.alpha = 1
        }

        let rotateTransform = CATransform3DMakeRotation(90, 0, 0, 0)

            UIView.animateWithDuration(
                0.2,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { () -> Void in
                    self.eyeButton.layer.transform = rotateTransform
                },
                completion: nil)




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
        if textView.text == currentQuote! || textView.text == currentQuote! + " " || textView.text == currentQuote! + finishItSuffix || textView.text == currentQuote! + ""{
            moveCursor()
            let alert  = UIAlertController(title: "WOAH NOW", message: "You didn't finish it. Get it together.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {

            sender.animateTouchUpInside {
                print("touched")
                self.animationImageView.animateWithNameAndFrames("savedLibAnimation", frames: 47)
                self.eyeButton.alpha = 0
                self.textView.hidden = true
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
        print("dismiss")
        textView.hidden = false
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
        let fullString: NSString = currentQuote! + finishItSuffix

        let rangeOfText = (fullString).rangeOfString(finishItSuffix, options: .CaseInsensitiveSearch)
        let stringForPlayer = attrText.mutableCopy() as! NSMutableAttributedString

        UIView.transitionWithView(textView, duration: 0.75, options: [.Repeat, .AllowUserInteraction], animations: { () -> Void in
            stringForPlayer.addAttribute(
                NSForegroundColorAttributeName,
                value: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3),
                range: rangeOfText)
            self.textView.attributedText = stringForPlayer
            }, completion: { (finished) -> Void in
                UIView.transitionWithView(self.textView, duration: 1.25, options: [.Autoreverse, .CurveEaseInOut, .TransitionCrossDissolve, .Repeat, .AllowUserInteraction], animations: { () -> Void in
                    stringForPlayer.addAttribute(
                        NSForegroundColorAttributeName,
                        value: UIColor.whiteColor(),
                        range: rangeOfText)
                    self.textView.attributedText = stringForPlayer
                    }, completion: nil)
        })

    




        if quoteSelected == true {
            self.textView.attributedText = attrText
//            self.moveCursor(self.textView)
            UIView.animateWithDuration(1.0, animations: {
                //self.quoteOfDayLabel.alpha = 1
            })
        }
    }


    /* Textfield Delegate Methods */

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

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        guard let text2 = textView.text else { return true }

        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }


        let newLength = text2.characters.count
        let length = limitLength - newLength
        characterLabel.text = "\(length)"
        //print("length is \(length)")
        print(currentQuote?.characters.count)
        if let quoteLength = currentQuote?.characters.count {

            if isAcceptableTextLength(range) {

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


    func addFinishItText() -> NSMutableAttributedString {
        let fontsize: CGFloat = 33
        let sentinelSemiBold = UIFont(name: "Sentinel-SemiBold", size: fontsize)
        let sentinelDict = NSDictionary(object: sentinelSemiBold!, forKey: NSFontAttributeName)
        let finishIt = NSMutableAttributedString(string: finishItSuffix, attributes: sentinelDict as? [String : AnyObject])
        //finishIt.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 166/255, green: 175/255, blue: 228/255, alpha: 1), range: NSRange(location: 0, length: finishIt.length))
        finishIt.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3), range: NSRange(location: 0, length: finishIt.length))
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
            buttonOne?.selected = true
            showQuotes()
        } else if sender.tag == 2 {
            showTweets()
            buttonOne?.selected = true
        }
    }

    func showQuotes() {
        print("show quotes")
        fanButtons()
        self.performSegueWithIdentifier("showList", sender: self)
    }

    func showTweets() {
        print("show tweets")
        fanButtons()
        self.performSegueWithIdentifier("showTweets", sender: self)

    }

    @IBAction func unwindToRed(segue: UIStoryboardSegue) {
        print("I unwinded")
        selectedQuoteOfDay()
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
        self.characterLabel.alpha = 1
    }

    func textViewDidEndEditing(textView: UITextView) {
        self.characterLabel.alpha = 0
    }

    func moveCursor() {
        textView.layer.removeAllAnimations()
        let finishIt = addFinishItText()
        let length = (currentQuote?.characters.count)! - finishIt.length

        if textView.text == currentQuote! + finishItSuffix {
            print("move cursor")
            textView.selectedRange = NSMakeRange(length, 0)
            let stringRange = textView.text.rangeOfString(finishIt.string)
            if textView.text.containsString(finishItSuffix) {
                textView.text.removeRange(stringRange!)
            }
            if textView.positionFromPosition(textView.beginningOfDocument, inDirection: UITextLayoutDirection.Right, offset: (currentQuote?.characters.count)!) != nil {

                textView.text = currentQuote! + " "
            }

        } else {print("dont move")}


//        if (currentQuote?.characters.count)! <= textView.text.characters.count {
//            print("don't move")
//        } else {
//
//        }
    }

    func isAcceptableTextLength(range: NSRange) -> Bool {
        return (currentQuote?.characters.count)! + limitLength > range.location
    }



    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func onShareButtonTapped(sender: FinishedButton) {

        sender.animateTouchUpInside { 
            print("share")
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 500, height: 280), false, 0)
            let context: CGContextRef = UIGraphicsGetCurrentContext()!
            CGContextSetRGBFillColor(context, 48/255, 60/255, 125/255, 1)
            CGContextFillRect(context, CGRect(x: 0.0, y: 0.0, width: 500, height: 280))


            let quoteText = self.buildQuoteWithFontSize(33)


            let rect = quoteText.boundingRectWithSize(CGSizeMake(400, 10000), options: .UsesLineFragmentOrigin, context: nil)

            let yPoint = CGFloat((280 - rect.height)/2)

            CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)

            quoteText.drawWithRect(CGRect(x: 60, y: yPoint, width: 400, height: 180), options: .UsesLineFragmentOrigin, context: nil)


            let wizard = UIImage(named: "WizardCornerIcon")
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
        let rangeOfQuote = startIndex..<self.textView.text.characters.endIndex
        self.enteredText = self.textView.text.substringWithRange(rangeOfQuote)
        print(self.enteredText)

        let sentinelBook = UIFont(name: "Sentinel-Book", size: fontsize)
        let textColor = UIColor.whiteColor()

        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: textColor,
            NSFontAttributeName: sentinelBook!
        ]

        let aAttrString = NSMutableAttributedString(string: self.currentQuote!, attributes: attributes as? [String : AnyObject])

        let sentinelSemiBold = UIFont(name: "Sentinel-SemiBold", size: fontsize)

        let attributes2: NSDictionary = [
            NSForegroundColorAttributeName: textColor,
            NSFontAttributeName: sentinelSemiBold!
        ]


        let bAttrString = NSMutableAttributedString(string: self.enteredText!
            , attributes: attributes2 as? [String : AnyObject])

        aAttrString.appendAttributedString(bAttrString)

        paragraphStyle.alignment = .Left

        let string = aAttrString

        return string

    }

    func finishedAnimation() {
        animationImageView.animateSparkles("Sparkles", frames: 22)
        shareButton.alpha = 0
        finishedQuoteView.hidden = false
        shareButton.hidden = false
        finishedQuoteView.alpha = 1
        blurView.animate()

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

    func loadTextView() {
        self.textView.hidden = false
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


            UIView.animateWithDuration(1, delay: 0.7, options: .CurveEaseInOut, animations: {
                self.finishedButton.alpha = 1
            }, completion: nil)

            let rangeOfText = (textView.text as NSString).rangeOfString(finishItSuffix, options: .CaseInsensitiveSearch)
            let stringForPlayer = textView.attributedText.mutableCopy() as! NSMutableAttributedString

            UIView.transitionWithView(textView, duration: 0.75, options: [.Repeat, .AllowUserInteraction], animations: { () -> Void in
                stringForPlayer.addAttribute(
                    NSForegroundColorAttributeName,
                    value: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3),
                    range: rangeOfText)
                self.textView.attributedText = stringForPlayer
                }, completion: { (finished) -> Void in
                    UIView.transitionWithView(self.textView, duration: 1.25, options: [UIViewAnimationOptions.Autoreverse, .CurveEaseInOut, .TransitionCrossDissolve, .Repeat, .AllowUserInteraction], animations: { () -> Void in
                        stringForPlayer.addAttribute(
                            NSForegroundColorAttributeName,
                            value: UIColor.whiteColor(),
                            range: rangeOfText)
                        self.textView.attributedText = stringForPlayer
                        }, completion: nil)
            })

        }

        UIView.animateWithDuration(1.0, animations: {
            self.textView.alpha = 1
        })

    }

    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
//        if buttonOne?.selected == true {
//            transition.startingPoint = buttonOne!.center
//        } else {
//            transition.startingPoint = buttonTwo!.center
//        }
        transition.startingPoint = eyeButton.center


        transition.duration = 0.4
        transition.bubbleColor = UIColor(red: 75/255, green: 91/255, blue: 175/255, alpha: 1)
        return transition
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = eyeButton.center
//        UIView.animateWithDuration(0.3) {
//            dismissed.view.alpha = 0
//        }
        transition.bubbleColor = UIColor(red: 75/255, green: 91/255, blue: 175/255, alpha: 1)
        return transition
    }

    func createBodyEditor()
    {
        // Register observers for keyboard show/hide states and update height property
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()

        notificationCenter.addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: mainQueue) { notification in
            if let rectValue = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue
            {
                self.keyboardHeight = rectValue.CGRectValue().size.height
            }
        }

        notificationCenter.addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: mainQueue) { notification in
            self.keyboardHeight = 0
        }

        // Create a button bar for the number pad
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        //doneToolbar.barTintColor = UIColor(red: 52/255, green: 62/255, blue: 139/255, alpha: 1)
        //doneToolbar.barTintColor = UIColor.darkGrayColor()
        doneToolbar.barStyle = .Black

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(HomeViewController.hideKeyboard))
        if let font = UIFont(name: "Sentinel-SemiBold", size: 18) {
            done.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        done.tintColor = UIColor.whiteColor()


        doneToolbar.items = [flexSpace, done, flexSpace]
        doneToolbar.sizeToFit()

        self.textView.inputAccessoryView = doneToolbar
    }

    func hideKeyboard()
    {
        view.endEditing(true)
    }


    func animateEyeball() {

        if areButtonsFanned == false {

        let duration = CFTimeInterval.init(48)
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "contents")
        animation.calculationMode = kCAAnimationDiscrete;
        animation.duration = duration / 24 // 24 frames per second
        animation.values = imagesArray.map {$0.CGImage as! AnyObject}
        animation.repeatCount = 1
        animation.delegate = self

        eyeButton.imageView!.layer.addAnimation(animation, forKey: "animation")

        }
    }






}

