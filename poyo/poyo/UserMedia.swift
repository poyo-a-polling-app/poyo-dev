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
        media["option1Answers"] = []
        media["option2Answers"] = []
        media["timeLimit"] = timeLimit
        media["time"] = date
        media["comments"] = []
//        media["option1Color"] = colorOneChoice
//        media["option2Color"] = colorTwoChoice


//        print("did it work?")

        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }

    class func postPoyoWithEndTime(withCaption caption: String?, withCaption longitude: String?, withCaption latitude: String?, withCaption optionOne: String?, withCaption optionTwo: String?, withCaption timeLimit: String?, withCompletion completion: PFBooleanResultBlock?) {
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
        media["timeLimit"] = timeLimit
        print("did it work?")

        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }


    class func killPoyo(poyo: PFObject?) {
        var deadMedia = PFObject(className: "ShakPoyoGrave")
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

        deadMedia["option1Answers"] = poyo!["option1Answers"]
        deadMedia["option2Answers"] = poyo!["option2Answers"]

        //print("hey kill was accessed")

        deadMedia.saveInBackgroundWithBlock { (success: Bool, error:NSError?) -> Void in
            if(success) {
                //print("sucess bitch")
                poyo?.deleteInBackground()

            } else {
                print(error)
            }
        }


    }


    class func postPoyoImage(withCaption caption: String?, withCaption longitude: String?, withCaption latitude: String?, withCaption optionOne: String?, withCaption optionTwo: String?, withCaption timeLimit: String?, imageOne: UIImage?, imageTwo: UIImage?, withCaption colorOneChoice: String?, withCaption colorTwoChoice: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "PoyosImageTest")
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
        media["option1Answers"] = []
        media["option2Answers"] = []
        media["timeLimit"] = timeLimit
        media["time"] = date
        media["option1Color"] = colorOneChoice
        media["option2Color"] = colorTwoChoice


        media["optionImageOne"] = getPFFileFromImage(imageOne)

        media["optionImageTwo"] = getPFFileFromImage(imageTwo)

        print("did it work?")

        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }
    
    class func postPrivatePoyo(withCaption caption: String?, withCaption longitude: String?, withCaption latitude: String?, withCaption optionOne: String?, withCaption optionTwo: String?, withCaption timeLimit: String?, imageOne: UIImage?, imageTwo: UIImage?, withCaption password: String?, withCaption colorOneChoice: String?, withCaption colorTwoChoice: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "postPrivatePoyoKevin")
        let date = NSDate()

        // Add relevant fields to the object
        //media["media"] = getPFFileFromImage(image) // PFFile column type
        media["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        media["username"] = PFUser.currentUser()?.username
        media["caption"] = caption
        media["longitude"] = longitude
        media["latitude"] = latitude
        //media["likesCount"] = 0
        media["commentsCount"] = 0
        media["optionOne"] = optionOne
        media["optionTwo"] = optionTwo
        media["option1Answers"] = []
        media["option2Answers"] = []
        media["timeLimit"] = timeLimit
        media["time"] = date
        media["password"] = password
        media["option1Color"] = colorOneChoice
        media["option2Color"] = colorTwoChoice


        media["optionImageOne"] = getPFFileFromImage(imageOne)

        media["optionImageTwo"] = getPFFileFromImage(imageTwo)

        print("did it fucking work?")

        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }

    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }


}
