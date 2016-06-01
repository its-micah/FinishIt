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

extension UIViewController {
    }

class HomeViewController: UIViewController, FinishedQuoteViewProtocol, DismissProtocol, UITextFieldDelegate {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var quoteOfDayLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var quotesButton: UIButton!
    private var accessToken: String?
    private let consumerKey = "dIS3vBfYpu5a87L6zSLV0ab3f"
    private let consumerSecret = "joYbUyXHwdQOtBpc6ULOSfGMrCok6ytqpcraR3mGzHcXpuR939"
    private let baseUrlString = "https://api.twitter.com/1.1/"
    var quote = Quote(quoteText:"")
    var selectedQuote: String?
    var quoteSelected: Bool?
    var currentUser: User?
    var areButtonsFanned: Bool?
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
    @IBOutlet weak var animationImageView: UIImageView!
    @IBOutlet weak var quoteLabelTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        eyeButton.addTarget(self, action: #selector(HomeViewController.fanButtons), forControlEvents: UIControlEvents.TouchUpInside)
        buttonOne?.addTarget(self, action: #selector(HomeViewController.showQuotes), forControlEvents: .TouchUpInside)
        buttonTwo?.addTarget(self, action: #selector(HomeViewController.showTweets), forControlEvents: .TouchUpInside)
//
//        for familyName in UIFont.familyNames() { if let fn = familyName as? String { for font in UIFont.fontNamesForFamilyName(fn) { print("font: \(font)") } } }

//        let client = TWTRAPIClient()
//        let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json?q=%40FinishIt"
//        let params = ["id": "20"]
//        var clientError : NSError?
//
//        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
//
//        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
//            if connectionError != nil {
//                print("Error: \(connectionError)")
//            }
//
//            do {
//                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
//                print("json: \(json)")
//            } catch let jsonError as NSError {
//                print("json error: \(jsonError.localizedDescription)")
//            }
//        }

        swifter = Swifter(consumerKey: "dIS3vBfYpu5a87L6zSLV0ab3f", consumerSecret: "joYbUyXHwdQOtBpc6ULOSfGMrCok6ytqpcraR3mGzHcXpuR939", appOnly: true)
        swifter!.authorizeAppOnlyWithSuccess({ (accessToken, response) -> Void in
            print("success - access token is \(accessToken)")
            self.swifter!.getUsersShowWithScreenName("ItIsFinishedApp", includeEntities: true, success: { (user) in
                if let userDict = user {
                    if let userId = userDict["id_str"] {
                        //self.getTwitterStatusWithUserId(userId.string!)
                        self.getTweetsFromHashtag()
                    }
                }
                }, failure: { (error) in
                    print(error)
            })
            }, failure: { (error) -> Void in
                print("Error Authenticating: \(error.localizedDescription)")
        })

    }

    func getTwitterStatusWithUserId(idString: String) {
        let failureHandler: ((error: NSError) -> Void) = {
            error in
            print("Error: \(error.localizedDescription)")
        }

        swifter!.getStatusesUserTimelineWithUserID(idString, count: 20, sinceID: nil, maxID: nil, trimUser: true, contributorDetails: false, includeEntities: true, success: {
            (statuses: [JSONValue]?) in

            if statuses != nil {

                var array: Array<Tweet> = []

                for post in statuses! {
                    let entities = post["extended_entities"] as JSONValue
                    let media = entities["media"] as JSONValue
                    let mediaArray = media[0]
                    let url = mediaArray["media_url"]
                    print(url)
                    let tweet = Tweet(twitterUsername: "ItIsFinished", imageURL: url.string!, twitterUserImageURL: url.string!)
                    array.append(tweet)
                }


                self.tweets = array
            }
            
            }, failure: failureHandler)


    }

    func getTweetsFromHashtag() {
        swifter?.getSearchTweetsWithQuery("#ItIsFinishedApp", geocode: nil, lang: "und", locale: nil, resultType: nil, count: 10, until: nil, sinceID: nil, maxID: nil, includeEntities: true, callback: nil, success: { (statuses, searchMetadata) in

            print(statuses?.count)
            var array: Array<Tweet> = []

            for status in statuses! {
                let user = status["user"]
                let username = user["name"].string
                let userImage = user["profile_image_url"].string
                let entities = status["entities"]
                let media = entities["media"]
                let mediaArray = media[0]
                var url = mediaArray["media_url"].string
                if url == nil {
                    url = ""
                }
                print(url)
                let tweet = Tweet(twitterUsername: username!, imageURL: url!, twitterUserImageURL: userImage!)
                array.append(tweet)
            }
            self.tweets = array


            }, failure: { (error) in
                print(error)
        })

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
        areButtonsFanned = !areButtonsFanned!
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
                self.animateSavedLibView()

                self.resignFirstResponder()
                self.finishedQuoteView.hidden = false
                self.finishedQuoteView.alpha = 1

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
        for name in ["savedLibAnimation_0.png", "savedLibAnimation_1.png", "savedLibAnimation_2.png", "savedLibAnimation_3.png", "savedLibAnimation_4.png", "savedLibAnimation_5.png", "savedLibAnimation_6.png", "savedLibAnimation_7.png", "savedLibAnimation_8.png", "csavedLibAnimation_9.png","savedLibAnimation_10.png", "savedLibAnimation_11.png", "savedLibAnimation_12.png", "savedLibAnimation_13.png", "savedLibAnimation_14.png", "savedLibAnimation_15.png", "savedLibAnimation_16.png", "savedLibAnimation_17.png", "savedLibAnimation_18.png", "savedLibAnimation_19.png", "csavedLibAnimation_20.png", "savedLibAnimation_21.png", "savedLibAnimation_22.png", "savedLibAnimation_23.png", "savedLibAnimation_24.png", "savedLibAnimation_25.png", "savedLibAnimation_26.png", "savedLibAnimation_27.png", "savedLibAnimation_28.png", "savedLibAnimation_29.png"] {
            if let image = UIImage(named: name) {
                imagesArray.append(image)
            }
        }

        animationImageView.animationImages = imagesArray
        animationImageView.animationDuration = 0.8
        animationImageView.animationRepeatCount = 1
        animationImageView.startAnimating()


    }

    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.3) { 
            self.finishedButton.alpha = 0
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        UIView.animateWithDuration(0.4) {
            self.finishedButton.alpha = 1
        }
        return false
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
    }

    func showQuotes() {
        print("show quotes")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let quotes = mainStoryboard.instantiateViewControllerWithIdentifier("ListVC") as! ListViewController
        self.presentViewController(quotes, animated: true, completion: nil)
    }

    func showTweets() {
        print("show tweets")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let tweetVC = mainStoryboard.instantiateViewControllerWithIdentifier("TweetVC") as! TweetsViewController
        tweetVC.tweets = self.tweets
        self.presentViewController(tweetVC, animated: true, completion: nil)

    }



}

