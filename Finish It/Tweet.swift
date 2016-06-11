//
//  Tweet.swift
//  Finish It
//
//  Created by Micah Lanier on 5/24/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import Foundation
import SwifteriOS


struct Tweet {
    let twitterUsername: String
    let imageURL: String
    let twitterUserImageURL: String
    let screenName: String
    let time: String


    init?(status: JSONValue) {

        guard let creationTime = status["created_at"].string, let entities = status["entities"].object, let user = status["user"].object else {
            return nil
        }

        guard let username = user["name"]?.string, let screenName = user["screen_name"]?.string, let userImage = user["profile_image_url_https"]?.string else {
            return nil
        }

        guard let media = entities["media"] else {
            return nil
        }

        guard let url = media[0]["media_url"].string else {
            return nil
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        let date = dateFormatter.dateFromString(creationTime)
        let elapsedTime = date?.getElapsedInterval()


        self.imageURL = url
        self.screenName = "@\(screenName)"
        self.time = elapsedTime!
        self.twitterUserImageURL = userImage
        self.twitterUsername = username

    }

//    func constructWithStatus(status: SwifteriOS.JSON) -> Tweet {
//        let user = status["user"]
//        let username = user["name"].string
//        let screenName = "@\(user["screen_name"].string!)"
//        let userImage = user["profile_image_url"].string
//        let creationTime = status["created_at"].string
//
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
//        let date = dateFormatter.dateFromString(creationTime!)
//        let testDate = date?.getElapsedInterval()
//        print(testDate)
//        let entities = status["entities"]
//        let media = entities["media"]
//        let mediaArray = media[0]
//        var url = mediaArray["media_url"].string
//        if url == nil {
//            url = ""
//        }
//        print(url)
//        let tweet = Tweet(twitterUsername: username!, imageURL: url!, twitterUserImageURL: userImage!, screenName: screenName, time: testDate!)
//        return tweet
//
//    }

}