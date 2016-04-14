//
//  PrivateViewController.swift
//  poyo
//
//  Created by Shakeeb Majid on 4/14/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import Parse

class PrivateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var distributionKeyField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var privatePoyos: [PFObject]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFind(sender: AnyObject) {
        let username = usernameField.text!
        let distroKey = distributionKeyField.text!
        
        var query = PFQuery(className:"postPrivatePoyoKevin")
        query.whereKey("username", equalTo: username)
        query.whereKey("password", equalTo: distroKey)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.privatePoyos = []
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.privatePoyos!.append(object)
                        
                        print(object.objectId)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.tableView.reloadData()
        }
        
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let privatePoyos = privatePoyos {
            return privatePoyos.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListedPoyoViewCell", forIndexPath: indexPath) as! ListedPoyoViewCell
        
        let privatePoyo = privatePoyos![indexPath.row]
        
        
        cell.questionLabel.text = privatePoyo["caption"] as! String
        
        
        
        
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
