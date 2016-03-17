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
    class func postPoyo(withCaption caption: String?, withCaption longitude: String?, withCaption latitude: String?, withCaption optionOne: String?, withCaption optionTwo: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "Poyos")
        let date = NSDate()
        
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
        media["time"] = date
        
        print("did it work?")
        
        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }
    
    class func postPoyoWithEndTime(withCaption caption: String?, withCaption longitude: String?, withCaption latitude: String?, withCaption optionOne: String?, withCaption optionTwo: String?, withCaption endTime: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "Poyos")
        let date = NSDate()
        
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
        media["time"] = date
        
        print("did it work?")
        
        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }

    
    class func killPoyo(poyo: PFObject?) {
        var deadMedia = PFObject(className: "PoyoGrave")
        //deadMedia = poyo!
        
        // Add relevant fields to the object
        //media["media"] = getPFFileFromImage(image) // PFFile column type
        deadMedia["author"] = poyo!["author"] // Pointer column type that points to PFUser
        deadMedia["caption"] = poyo!["caption"]
        deadMedia["longitude"] = poyo!["longitude"]
        deadMedia["latitude"] = poyo!["latitude"]
        //media["likesCount"] = 0
        deadMedia["commentsCount"] = poyo!["commentsCount"]
        deadMedia["optionOne"] = poyo!["optionOne"]
        deadMedia["optionTwo"] = poyo!["optionTwo"]
        deadMedia["time"] = poyo!["time"]
    
        print("hey kill was accessed")
        
        deadMedia.saveInBackgroundWithBlock { (success: Bool, error:NSError?) -> Void in
            if(success) {
                print("sucess bitch")
                poyo?.deleteInBackground()
                
            } else {
                print(error)
            }
        }
       
        
    }
    
}

