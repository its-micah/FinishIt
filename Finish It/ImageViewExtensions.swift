//
//  ImageViewExtensions.swift
//  Finish It
//
//  Created by Micah Lanier on 5/24/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func downloadFrom(link link:String?, contentMode mode: UIViewContentMode) {
        contentMode = mode
        if link == nil {
            self.image = UIImage(named: "default")
            return
        }
        if let url = NSURL(string: link!) {
            //print("\nstart download: \(url.lastPathComponent!)")
            NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
                guard let data = data where error == nil else {
                    print("\nerror on download \(error)")
                    return
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    print("\ndownload completed \(url.lastPathComponent!)")
                    self.image = UIImage(data: data)
                    self.layoutSubviews()

                }
            }).resume()
        } else {
            self.image = UIImage(named: "default")
        }
    }

}