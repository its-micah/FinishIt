//
//  DataService.swift
//  Finish It
//
//  Created by Micah Lanier on 4/15/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import Foundation
import SwifteriOS


public extension NSBundle {

    /**
     Gets the contents of the specified plist file.

     - parameter plistName: property list where defaults are declared
     - parameter bundle: bundle where defaults reside

     - returns: dictionary of values
     */
    public static func contentsOfFile(plistName: String, bundle: NSBundle? = nil) -> [String : AnyObject] {
        let fileParts = plistName.componentsSeparatedByString(".")

        guard fileParts.count == 2,
            let resourcePath = (bundle ?? NSBundle.mainBundle()).pathForResource(fileParts[0], ofType: fileParts[1]),
            let contents = NSDictionary(contentsOfFile: resourcePath) as? [String : AnyObject]
            else { return [:] }

        return contents
    }

}

class DataService {
    static let dataService = DataService()

    var tweets:[Tweet] = [] {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("tweetsFetched", object: nil)
        }
    }

    func getQuote() -> String {

        let values = NSBundle.contentsOfFile("QuoteOfDay.plist")
        print(values["Quotes"]) //


        guard let quotes = values["Quotes"] as? Array<String> else {

            return "My favorite time of year is"
        }

        let today =  NSDate()

        let formatter = NSDateFormatter.init()
        formatter.dateStyle = .ShortStyle

        let cal = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = 6
        dateComponents.day = 25
        dateComponents.year = 2016

        let startDate = cal.dateFromComponents(dateComponents)
        let unit = NSCalendarUnit.Day


        let components = cal.components(unit, fromDate: startDate!, toDate: today, options: NSCalendarOptions.MatchFirst)
        print(components.day)
        let quoteCount = quotes.count

        let quote = quotes[components.day % quoteCount]



        return quote
    }


    func getQuoteList() -> Array<Quote> {

        let values = NSBundle.contentsOfFile("QuoteOfDay.plist")
        print(values["Quotes"]) 


        guard let quotes = values["Quotes"] as? Array<String> else {
            return []
        }


        var quoteArray: Array<Quote> = []


        let today =  NSDate()
        let cal = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = 6
        dateComponents.day = 25
        dateComponents.year = 2016

        let startDate = cal.dateFromComponents(dateComponents)
        let unit = NSCalendarUnit.Day
        let components = cal.components(unit, fromDate: startDate!, toDate: today, options: NSCalendarOptions.MatchFirst)
        print(components.day)
        let quoteCount = quotes.count

        var index = components.day % quoteCount
        index -= 1

        for _ in 0...25 {
            if index == -1 {
                index = quotes.count - 1
            }

            let quote = Quote(quoteText: quotes[index])
            quoteArray.append(quote)
            index -= 1
        }

        return quoteArray

    }

}
