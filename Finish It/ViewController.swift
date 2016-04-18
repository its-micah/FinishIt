//
//  ViewController.swift
//  Finish It
//
//  Created by Micah Lanier on 4/14/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit
import Firebase
import TKSubmitTransition
import pop

class ViewController: UIViewController {

    @IBOutlet weak var quoteOfDayLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lineView: UIView!
    let ref = Firebase(url: "https://finishit.firebaseIO.com")
    var quote = Quote(quoteText:"")
    @IBOutlet var finishedButton: UIButton!

    @IBOutlet weak var quoteLabelTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        quoteLabelTopConstraint.constant = -30
        lineView.alpha = 0
        textField.alpha = 0

    }

    override func viewDidAppear(animated: Bool) {
        quoteOfDayLabel.alpha = 0
        DataService.dataService.QUOTE_OF_DAY_REF.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            let quoteDict = snapshot.value as! NSDictionary
            let quote = Quote(quoteText: quoteDict.objectForKey("quoteText") as! String)
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
            }, completion: nil)
            
        })

    }
    
    
    @IBAction func onFinishedButtonTapped(sender: AnyObject) {
        print("button tapped")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

