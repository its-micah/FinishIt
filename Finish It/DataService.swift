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


}