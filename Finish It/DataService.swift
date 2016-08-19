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
        let startDate = formatter.dateFromString("07/06/16")
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
        let startDate = formatter.dateFromString("05/12/16")
        let cal = NSCalendar.currentCalendar()
        let unit = NSCalendarUnit.Day
        let components = cal.components(unit, fromDate: startDate!, toDate: today, options: NSCalendarOptions.MatchFirst)
        print(components.day)
        var index = components.day
        var counter:Int = 0

        if index > quotes.count {
            index = 40
        }

        for q in quotes {
            if counter > index - 40 && counter < index {
                let quote = Quote(quoteText: q as! String)
                quoteArray.append(quote)
            }
            counter += 1
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

//    func getTweetsFromHashtag(hashtag: String) {
//        swifter?.getSearchTweetsWithQuery(hashtag, geocode: nil, lang: "und", locale: nil, resultType: nil, count: 10, until: nil, sinceID: nil, maxID: nil, includeEntities: true, callback: nil, success: { (statuses, searchMetadata) in
//
//            print(statuses?.count)
//            var array = [Tweet]()
//
//            for status in statuses! {
//                let user = status["user"]
//                let username = user["name"].string
//                let screenName = user["screen_name"].string
//                let userImage = user["profile_image_url"].string
//                let creationTime = status["created_at"].string
//                let dateFormatter = NSDateFormatter()
//                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//                dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
//                let date = dateFormatter.dateFromString(creationTime!)
//                let testDate = date?.getElapsedInterval()
//                print(testDate)
//
//                let entities = status["entities"]
//                let media = entities["media"]
//                let mediaArray = media[0]
//                var url = mediaArray["media_url"].string
//                if url == nil {
//                    url = ""
//                }
//                print(url)
//                let tweet = Tweet(twitterUsername: username!, imageURL: url!, twitterUserImageURL: userImage!, screenName: screenName!, time: testDate!)
//                array.append(tweet)
//            }
//            self.tweets = array
//
//            }, failure: { (error) in
//                print(error)
//        })
//    }















}