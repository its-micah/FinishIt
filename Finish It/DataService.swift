//
//  DataService.swift
//  Finish It
//
//  Created by Micah Lanier on 4/15/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()

    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _QUOTE_REF = Firebase(url: "\(BASE_URL)/Quotes")
    private var _QUOTE_OF_DAY_REF = Firebase(url: "\(BASE_URL)/Quotes/quoteOfDay")
    private var _QUOTE_LIST_REF = Firebase(url: "\(BASE_URL)/Quotes/quoteList")

    var BASE_REF: Firebase {
        return _BASE_REF
    }

    var QUOTE_REF: Firebase {
        return _QUOTE_REF
    }

    var QUOTE_OF_DAY_REF: Firebase {
        return _QUOTE_OF_DAY_REF
    }

    var QUOTE_LIST_REF: Firebase {
        return _QUOTE_LIST_REF
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
        let startDate = formatter.dateFromString("05/05/16")
        let cal = NSCalendar.currentCalendar()
        let unit = NSCalendarUnit.Day
        let components = cal.components(unit, fromDate: startDate!, toDate: today, options: NSCalendarOptions.MatchFirst)
        print(components.day)
        quote = quotes[components.day] as? String

        return quote!
    }


}