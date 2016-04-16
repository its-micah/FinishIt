//
//  CreateQuoteViewController.swift
//  Finish It
//
//  Created by Micah Lanier on 4/16/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit

class CreateQuoteViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    var quote: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        quoteLabel.text = quote
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
