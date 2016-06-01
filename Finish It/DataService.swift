//
//  DataService.swift
//  Finish It
//
//  Created by Micah Lanier on 4/15/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import Foundation

class DataService {
    static let dataService = DataService()


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
        let startDate = formatter.dateFromString("05/31/16")
        let cal = NSCalendar.currentCalendar()
        let unit = NSCalendarUnit.Day
        let components = cal.components(unit, fromDate: startDate!, toDate: today, options: NSCalendarOptions.MatchFirst)
        print(components.day)
        quote = quotes[components.day] as? String

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
            index = 15
        }

        for q in quotes {
            if counter > index - 15 && counter < index {
                let quote = Quote(quoteText: q as! String)
                quoteArray.append(quote)
            }
            counter += 1
        }


        
        return quoteArray

    }














}