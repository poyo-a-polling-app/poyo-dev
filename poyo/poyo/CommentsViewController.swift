//
//  CommentsViewController.swift
//  poyo
//
//  Created by Takashi Wickes on 3/31/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import Parse
import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var passedPoyo: PFObject!
    var commentsArray: [NSDictionary]?
    
    @IBOutlet weak var newCommentTextField: UITextField!
    @IBOutlet weak var commentInputField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendCommentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        commentsArray = passedPoyo["comments"] as! [NSDictionary]
        
        print(passedPoyo)

        // Do any additional setup after loading the view.
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
        var newCommentString = commentInputField.text!
        
        let commentDate = commentsArray![indexPath.row]["timeStamp"]! as! NSDate
        print(commentDate)
        cell.commentTextLabel.text = commentsArray![indexPath.row]["commentString"] as! String
        cell.dateLabel.text = timeElapsed(commentDate)
        
        return cell
        
    }
    
    @IBAction func sendCommentPressed(sender: AnyObject) {
        
        var newCommentString = commentInputField.text!
        
        let newComment:NSDictionary = ["commentString": newCommentString, "user": PFUser.currentUser()! , "timeStamp": NSDate()]
        
        print("Comment attempted to post: \(newComment)")
        
        let query : PFQuery = PFQuery(className: "PoyosAnswers")
        
        query.whereKey("objectId", equalTo: passedPoyo.objectId!)
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
            
                var tempArray = object["comments"] as! [NSDictionary]
                tempArray.append(newComment as! NSDictionary)
             
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
        
        commentInputField.text = ""
    }
    
    func timeElapsed(date: NSDate) -> String {
        
        let timeElapsed = Int(0 - date.timeIntervalSinceNow)
        print("timeElapsed \(timeElapsed)")
        
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
}

class poyoComment{
    var commentString: String?
    var user: PFUser?
    var timeStamp: NSDate?
    
    init(newCommentString: String) {
        commentString = newCommentString
        user = PFUser.currentUser()
        timeStamp = NSDate()
    }
}

