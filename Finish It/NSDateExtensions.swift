//
//  NSDateExtensions.swift
//  Finish It
//
//  Created by Micah Lanier on 6/5/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import Foundation


extension NSDate {

    func getElapsedInterval() -> String {

        var interval = NSCalendar.currentCalendar().components(.Year, fromDate: self, toDate: NSDate(), options: []).year

        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "year" :
                "\(interval)" + " " + "years"
        }

        interval = NSCalendar.currentCalendar().components(.Month, fromDate: self, toDate: NSDate(), options: []).month
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "month" :
                "\(interval)" + " " + "months"
        }

        interval = NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: NSDate(), options: []).day
        if interval > 0 {
            return interval == 1 ? "\(interval)" + "d" :
                "\(interval)" + "d"
        }

        interval = NSCalendar.currentCalendar().components(.Hour, fromDate: self, toDate: NSDate(), options: []).hour
        if interval > 0 {
            return interval == 1 ? "\(interval)" + "h" :
                "\(interval)" + "h"
        }

        interval = NSCalendar.currentCalendar().components(.Minute, fromDate: self, toDate: NSDate(), options: []).minute
        if interval > 0 {
            return interval == 1 ? "\(interval)" + "m" :
                "\(interval)" + "m"
        }
        
        return "now"
    }
}