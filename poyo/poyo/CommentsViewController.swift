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
    
    @IBOutlet weak var commentInputField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
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
            return commentsArray.count
        } else {
            return 0
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentViewCell
        
        print(commentsArray![indexPath.row])
        cell.commentTextLabel.text = commentsArray![indexPath.row]["commentString"] as! String
        
        return cell
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class comment{
    var commentString: String?
    var user: PFUser?
    var timeStamp: NSDate?
}

