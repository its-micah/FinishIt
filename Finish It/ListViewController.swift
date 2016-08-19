//
//  ListViewController.swift
//  Finish It
//
//  Created by Micah Lanier on 4/16/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit

protocol getQuoteProtocol {
    func selectedQuoteOfDay()
}

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    var quotes = [Quote]()
    var quoteOfDay: String?
    var delegate: getQuoteProtocol?

    override func viewDidLoad() {
        let nib = UINib(nibName: "ListHeaderView", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "ListHeaderView")
        tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)

        
        self.quotes = DataService.dataService.getQuoteList()
        quoteOfDay = DataService.dataService.getQuote()
        self.tableView.reloadData()

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let quote = quotes[indexPath.row]
        cell.textLabel?.text = quote.quoteText + "..."
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "Sentinel", size: 18)
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("ListHeaderView")
        let header = cell as! ListHeaderView
        header.quoteLabel.text = quoteOfDay
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListViewController.handleTap))
        cell?.addGestureRecognizer(tapRecognizer)
        tableView.tableHeaderView = header
        return cell?.contentView
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.005
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //sizeHeaderToFit()
    }

    func handleTap() {
        self.delegate?.selectedQuoteOfDay()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCloseButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let selectedQuote = quotes[selectedPath!.row] as Quote
        let vc = segue.destinationViewController as! HomeViewController
        vc.currentQuote = selectedQuote.quoteText
    }

}
