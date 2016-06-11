//
//  TweetsViewController.swift
//  Finish It
//
//  Created by Micah Lanier on 5/21/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit
import SwifteriOS

class TweetsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var bar: UINavigationBar!
    @IBOutlet weak var tweetsCollectionView: UICollectionView!

    var tweets: Array<Tweet>?
    var swifter: Swifter?
    var refreshControl: UIRefreshControl?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsCollectionView.delegate = self

        bar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "EskapadeFraktur", size: 20.0)!,
                                                                         NSForegroundColorAttributeName: UIColor.whiteColor()]

        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(self.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tweetsCollectionView.addSubview(refreshControl!)


        activityIndicator.startAnimating()

        swifter = Swifter(consumerKey: "dIS3vBfYpu5a87L6zSLV0ab3f", consumerSecret: "joYbUyXHwdQOtBpc6ULOSfGMrCok6ytqpcraR3mGzHcXpuR939", appOnly: true)
        swifter!.authorizeAppOnlyWithSuccess({ (accessToken, response) -> Void in
            print("success - access token is \(accessToken)")
            self.swifter!.getUsersShowWithScreenName("ItIsFinishedApp", includeEntities: true, success: { (user) in
                        self.getTweetsFromHashtag()

                }, failure: { (error) in
                    print(error)
            })
            }, failure: { (error) -> Void in
                print("Error Authenticating: \(error.localizedDescription)")
        })


        // Do any additional setup after loading the view.
    }

    func getTweetsFromHashtag() {
        swifter?.getSearchTweetsWithQuery("#ItIsFinishedApp", geocode: nil, lang: "und", locale: nil, resultType: nil, count: 10, until: nil, sinceID: nil, maxID: nil, includeEntities: true, callback: nil, success: { (statuses, searchMetadata) in

            print(statuses?.count)
            var array: Array<Tweet> = []

            for status in statuses! {
                let tweet = Tweet.init(status: status)

                if let completeTweet = tweet {
                    array.append(completeTweet)
                }
            }
            self.tweets = array
            self.tweetsCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl?.endRefreshing()

            }, failure: { (error) in
                print(error)
        })
        
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(tweetsCollectionView.frame.size.width/1.05, tweetsCollectionView.frame.size.height/1.8)
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arr = tweets {
            return arr.count
        }
        return 0
    }


    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = tweetsCollectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TweetCollectionViewCell
        let tweet = tweets![indexPath.row]
        cell.configureWithTweet(tweet)
        cell.layoutIfNeeded()
        return cell

    }



    @IBAction func onCloseButtopTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func refresh() {
        
        getTweetsFromHashtag()
    }

//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
