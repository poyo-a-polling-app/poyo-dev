//
//  CommentsViewController.swift
//  poyo
//
//  Created by Takashi Wickes on 3/31/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import Parse
import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var passedPoyo: PFObject!
    var commentsArray: [NSDictionary]?
    var userAnswer: Int?
    var keyboardHeight:CGFloat = 300
    var firstMove = true
    

    @IBOutlet weak var commentInputField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputFieldView: UIView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    var animalFarm = ["ant-eater", "badger", "bear", "buffalo", "deer", "elephant", "fennec", "fox", "giraffe", "gorilla", "hedgehog", "hippopotamus", "hog", "jaguar", "koala", "lion", "monkey", "moose", "panda", "rabbit", " racoon", "rhinoceros", "sloth", "snake", "squirrel", "tiger", "turtle", "wild-horse", "wolf", "zebra"]

    @IBAction func inputStarted(sender: AnyObject) {
        
        animateViewMoving(true, moveValue: -keyboardHeight)

    }
    
    
    @IBAction func inputEnded(sender: AnyObject) {
        animateViewMoving(true, moveValue: keyboardHeight)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        commentInputField.delegate = self
        
        self.tabBarController?.tabBar.hidden = true
        
        commentsArray = passedPoyo["comments"] as? [NSDictionary]
        
        print(passedPoyo)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)


        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        keyboardHeight = keyboardRectangle.height
    }
    
    func randomChar() {
        //check if they have already answered
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let commentsArray = commentsArray {
            print(commentsArray.count)
            return commentsArray.count
        } else {
            return 0
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentViewCell
        
        cell.iconBackView.layer.cornerRadius = cell.iconBackView.frame.height / 2
        
        print("User = \(commentsArray![indexPath.row]["user"]?.objectId)")
        print("Current User --asd-- \(PFUser.currentUser()?.objectId)")
        if commentsArray![indexPath.row]["user"]?.objectId == PFUser.currentUser()?.objectId {
            print("ANSWER FROM CURRENT USER")
            switch userAnswer! {
            case 1:
                cell.iconBackView.backgroundColor = UIColor(red:0.09, green:0.7, blue:0.43, alpha:1.0)
            case 2:
                cell.iconBackView.backgroundColor = UIColor(red:0.87, green:0.2, blue:0.15, alpha:1.0)
            default:
                cell.iconBackView.backgroundColor = UIColor.whiteColor()
            }
        } else {
            print("ANSWER FROM NOTN NOTNONOTNOTNOT CURRENT USER")
            print("POOOP")

            let colorSet = findColor(commentsArray![indexPath.row]["user"] as! PFUser)
            switch colorSet {
            case 1:
                cell.iconBackView.backgroundColor = UIColor(red:0.09, green:0.7, blue:0.43, alpha:1.0)
            case 2:
                cell.iconBackView.backgroundColor = UIColor(red:0.87, green:0.2, blue:0.15, alpha:1.0)
            default:
                cell.iconBackView.backgroundColor = UIColor.whiteColor()
            }
        }
        
 
        
        
        let commentDate = commentsArray![indexPath.row]["timeStamp"]! as! NSDate
        print(commentDate)
        cell.commentTextLabel.text = commentsArray![indexPath.row]["commentString"] as? String
        cell.dateLabel.text = timeElapsed(commentDate)
        
        var animalString = commentsArray![indexPath.row]["anonCharacter"] as! String
        let origImage = UIImage(named: animalString)
        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//        btn.setImage(tintedImage, forState: .Normal)
//        btn.tintColor = UIColor.redColor()
        
        
        
        
        
        cell.anonCharacterImage.image = tintedImage

        
//        cell.anonCharacterImage.image = UIImage(named: animalString)
        cell.anonCharacterImage.tintColor = UIColor.whiteColor()
        
        return cell
        
    }
    
    func findColor(user: PFUser) -> Int {
        
        //search option1Array
//        let options1Array = passedPoyo["option1Answers"] as! [NSDictionary]
        print("POPOPOPOPOPOPOPOPOPOPOPO")
        
        var options1 = passedPoyo["option1Answers"] as! [NSDictionary]
        var options1Array = options1.map { $0["userId"] as! String}
        
        if options1Array.contains({$0 == user.objectId}){
            print("Answered 1")
            return 1
        }

        
        
        
        var options2 = passedPoyo["option2Answers"] as! [NSDictionary]
        var options2Array = options2.map { $0["userId"] as! String}
        
        if options2Array.contains({$0 == user.objectId}){
            print("Answered 2")
            return 2
        }
        
        
//        if options1Array.contains({$0 == user.objectId}){
//            print("Answered 1")
//            return 1
//        }
    
        //search option2Array
//        let options2Array = passedPoyo["option2Answers"] as! [NSDictionary]
//    
//        if options2Array.contains({$0 == user.objectId}){
//            print("Answered 2")
//            return 2
//        }
        print("None answered")
        return 0
    }
    
    func assignCharacter(commentsArray: [NSDictionary]) -> String {
        if let index = commentsArray.indexOf({$0["user"]!.objectId == PFUser.currentUser()?.objectId}) {
            print("User has already been assigned")
            return commentsArray[index]["anonCharacter"] as! String
        }
        
        while true{
            var randomInt = Int(arc4random_uniform(28))
            print("RandomInt: \(randomInt)")
            if commentsArray.contains({$0["anonCharacter"] as! String == animalFarm[randomInt]}) {
                print("Animal already used")
                continue
            } else {
                return animalFarm[randomInt]
            }
        }
        

    }
    
    @IBAction func sendCommentPressed(sender: AnyObject) {
        
        let newCommentString = commentInputField.text!
        
        
        
        
        if newCommentString != "" {
        
            
            
            let query : PFQuery = PFQuery(className: "PoyosImageTest")
            
            query.whereKey("objectId", equalTo: passedPoyo.objectId!)
            
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                
                
                

                for object in objects! {
                    
                    var tempArray: [NSDictionary]
                    if object["comments"] != nil {
                        tempArray = object["comments"] as! [NSDictionary]
                    } else {
                        tempArray = []
                    }
                    
                    var animalString = self.assignCharacter(tempArray)
                    
                    
                    let newComment:NSDictionary = ["commentString": newCommentString, "user": PFUser.currentUser()! , "timeStamp": NSDate(), "anonCharacter": animalString]
                    print("Comment attempted to post: \(newComment)")
                    
                    
                    
                    
                    tempArray.append(newComment)
                    object["comments"] = tempArray
                    
                    object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        if let error = error {
                            print("ERROR: Comment was not added to Parse")
                            print(error.localizedDescription)
                            
                        } else {
                            print("Comment was added successfully")
                            self.passedPoyo = object
                            self.commentsArray = self.passedPoyo["comments"] as? [NSDictionary]
                            
                            print(self.passedPoyo)
                            
                            self.tableView.reloadData()
                        }
                    }
                    
                }
                
            }

        }
        
        commentInputField.text = ""
    }
    
//    func adjustingHeight(show:Bool, notification:NSNotification) {
//        // 1
//        var userInfo = notification.userInfo!
//        // 2
//        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
//        // 3
//        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
//        // 4
//        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
//        //5
//        
//        UIView.setAnimationsEnabled(true)
//        
//        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: {
//            self.bottomConstraint.constant += changeInHeight
//
//            }, completion: { finished in
//                print("Done!")
//        })
//        
////        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: { () -> Void in
//////            self.inputFieldView.frame.origin.y += changeInHeight
////            self.bottomConstraint.constant += changeInHeight
////        })
//        
//    }
    
    func timeElapsed(date: NSDate) -> String {
        
        let timeElapsed = Int(0 - date.timeIntervalSinceNow)
        
        let secondsInMinute = 60
        let secondsInHour = secondsInMinute * 60
        let secondsInDay = secondsInHour * 24
        let secondsInMonth = secondsInDay * 30
        let monthsElapsed = timeElapsed/secondsInMonth
        let daysElapsed = timeElapsed/secondsInDay
        let hoursElapsed = timeElapsed/secondsInHour
        let minutesElapsed = timeElapsed/secondsInMinute
        let secondsElapsed = timeElapsed
        var timeElapsedString: String?
        
        if monthsElapsed != 0 {
            timeElapsedString = "\(monthsElapsed)mon"
            
        } else if daysElapsed != 0 {
            timeElapsedString = "\(daysElapsed)d"
            
            
        } else if hoursElapsed != 0 {
            timeElapsedString = "\(hoursElapsed)h"
            
            
        } else if minutesElapsed != 0 {
            timeElapsedString = "\(minutesElapsed)m"
            
        } else {
            timeElapsedString = "\(secondsElapsed)s"
        }
        return timeElapsedString!
    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        txtField.resignFirstResponder()
//        return true;
//    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        //        var movement:CGFloat = ( up ? -moveValue : moveValue)
        var movement:CGFloat = moveValue
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
//        self.view.frame.origin.y += movement
        UIView.commitAnimations()
        inputFieldView.hidden = false
    }
    
}

class poyoComment{
    var commentString: String?
    var user: PFUser?
    var timeStamp: NSDate?
    var anonCharacter: UIImage
    
    init(newCommentString: String) {
        commentString = newCommentString
        user = PFUser.currentUser()
        timeStamp = NSDate()
        anonCharacter = UIImage(named: "anteater")!
    }
}
