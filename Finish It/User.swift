//
//  User.swift
//  Finish It
//
//  Created by Micah Lanier on 4/29/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString!
    var profileImage: UIImage!
    static let appUser = User()
    

    func save() {
        if let image = profileImage {
            if let data = UIImagePNGRepresentation(image) {
                let filename = getDocumentsDirectory().stringByAppendingPathComponent("copy.png")
                data.writeToFile(filename, atomically: true)
            }
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
