//
//  ListViewController.swift
//  Finish It
//
//  Created by Micah Lanier on 4/16/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var quotes = [Quote]()

    override func viewDidLoad() {

        tableView.delegate = self

        DataService.dataService.QUOTE_LIST_REF.observeEventType(.Value, withBlock: { snapshot in
            self.quotes = []

            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let quoteDictionary = snap.value as? NSDictionary {
                        let quote = Quote(quoteText: quoteDictionary.objectForKey("quoteText") as! String)
                        // Items are returned chronologically, but it's more fun with the newest jokes first.

                        self.quotes.insert(quote, atIndex: 0)
                    }
                }
            }
            print(self.quotes.count)
            self.tableView.reloadData()
        })
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let quote = quotes[indexPath.row]
        cell.textLabel?.text = quote.quoteText
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedQuote = quotes[indexPath.row] as Quote
//
//    }

    
    @IBAction func onCloseButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let selectedQuote = quotes[selectedPath!.row] as Quote
        let vc = segue.destinationViewController as! ViewController
        vc.selectedQuote = selectedQuote.quoteText
    }

}
