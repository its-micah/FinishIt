//
//  ViewController.swift
//  Finish It
//
//  Created by Micah Lanier on 4/14/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var quoteOfDayLabel: UILabel!
    let ref = Firebase(url: "https://finishit.firebaseIO.com")
    var quote = Quote(quoteText:"")

    @IBOutlet weak var quoteLabelTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        quoteLabelTopConstraint.constant = -10

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

            UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                self.quoteLabelTopConstraint.constant = 100
                self.view.layoutIfNeeded()
                }, completion: nil)
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

