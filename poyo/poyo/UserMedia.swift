//
//  UserMedia.swift
//  poyo
//
//  Created by Kevin Asistores on 3/8/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import Parse

class UserMedia: NSObject {
    class func postPoyo(withCaption caption: String?, withCaption longitude: String?, withCaption latitude: String?, withCaption optionOne: String?, withCaption optionTwo: String?, withCaption timeLimit: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "Poyos")
        let date = NSDate()
        //print("time limit \(timeLimit!)")
        // Add relevant fields to the object
        //media["media"] = getPFFileFromImage(image) // PFFile column type
        media["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        media["caption"] = caption
        media["longitude"] = longitude
        media["latitude"] = latitude
        //media["likesCount"] = 0
        media["commentsCount"] = 0
        media["optionOne"] = optionOne
        media["optionTwo"] = optionTwo
        //print("hello i'm sorry i'm trying to get this to work kevin don't be mad or sad")
        //print("number: \(timeLimit)")
        media["timeLimit"] = timeLimit // timeLimit! as! String
        media["time"] = date
        
        
        print("did it work?")
        
        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }
}

