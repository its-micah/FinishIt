//
//  DataService.swift
//  Finish It
//
//  Created by Micah Lanier on 4/15/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import Foundation
import SwifteriOS

class DataService {
    static let dataService = DataService()
    var swifter: Swifter?

    var tweets:[Tweet] = [] {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("tweetsFetched", object: nil)
        }
    }

    func getQuote() -> String {

        var myDict: NSDictionary?
        var quote: String?
        if let path = NSBundle.mainBundle().pathForResource("QuoteOfDay", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }

        let quotes = myDict?.objectForKey("Quotes") as! NSArray

        let today =  NSDate()
        let formatter = NSDateFormatter.init()
        formatter.dateStyle = .ShortStyle
        let startDate = formatter.dateFromString("06/25/16")
        let cal = NSCalendar.currentCalendar()
        let unit = NSCalendarUnit.Day
        let components = cal.components(unit, fromDate: startDate!, toDate: today, options: NSCalendarOptions.MatchFirst)
        print(components.day)
        quote = quotes[components.day % quotes.count] as? String
        return quote!
    }


    func getQuoteList() -> Array<Quote> {

        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("QuoteOfDay", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }

        var quoteArray: Array<Quote> = []

        let quotes = myDict?.objectForKey("Quotes") as! NSArray

        let today =  NSDate()
        let formatter = NSDateFormatter.init()
        formatter.dateStyle = .ShortStyle
        let startDate = formatter.dateFromString("06/25/16")
        let cal = NSCalendar.currentCalendar()
        let unit = NSCalendarUnit.Day
        let components = cal.components(unit, fromDate: startDate!, toDate: today, options: NSCalendarOptions.MatchFirst)
        print(components.day)
//        var index = components.day
//        var counter:Int = 0


        var index = components.day % quotes.count
        index -= 1

        for i in 0...25 {
            if index == -1 {
                index = quotes.count - 1
            }

            let quote = Quote(quoteText: quotes[index] as! String)
            quoteArray.append(quote)
            index -= 1
        }


        
        return quoteArray

    }

    func getTweetsWithHashtag(hashtag: String) {
        swifter = Swifter(consumerKey: "dIS3vBfYpu5a87L6zSLV0ab3f", consumerSecret: "joYbUyXHwdQOtBpc6ULOSfGMrCok6ytqpcraR3mGzHcXpuR939", appOnly: true)
        swifter!.authorizeAppOnlyWithSuccess({ (accessToken, response) -> Void in
            print("success - access token is \(accessToken)")
            //self.getTweetsFromHashtag(hashtag)
//            self.swifter!.getUsersShowWithScreenName("ItIsFinishedApp", includeEntities: true, success: { (user) in
//                if let userDict = user {
//                    if let userId = userDict["id_str"] {
//                        //self.getTwitterStatusWithUserId(userId.string!)
//                        self.getTweetsFromHashtag()
//                    }
//                }
//                }, failure: { (error) in
//                    print(error)
//            })
            }, failure: { (error) -> Void in
                print("Error Authenticating: \(error.localizedDescription)")
        })

    }

}