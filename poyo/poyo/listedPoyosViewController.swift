
//
//  listedPoyosViewController.swift
//  poyo
//
//  Created by Takashi Wickes on 3/4/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import CoreLocation
import Parse


class listedPoyosViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var selectedIndexPath: NSIndexPath?

    var locationManager = CLLocationManager()
    var location: CLLocation!

    var frameAdded = false
    var chosenSaved = false


    var feed: [PFObject]?

    var radius: CLLocationDistance = 100
    
    var chosenOption = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        self.locationManager.requestAlwaysAuthorization()

//        chosenSaved = false
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            print("Location Successful")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            location = nil
        } else {
            print("No location")
        }

        reloadAllData()
        
        

    }
    
    override func viewWillAppear(animated: Bool) {
        populateChosenOption()

    }
    
    func reloadAllData() {
        print("RELOADING DATA!!!")
        let query = PFQuery(className:"PoyosAnswers")
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                
                
                //                self.feed = media
                //                self.tableView.reloadData()
                //                print(media)
                self.feed = media
                if !self.chosenSaved {
                    self.populateChosenOption()

                }

                self.tableView.reloadData()
                // do something with the data fetched
                print("IT ACCESSED THE DATA!!!!!")
            } else {
                print("COULD NOT ACCESS THE DATA")
                // handle error
            }
        }
        if chosenOption != [] {
            print("Chosen saved: \(chosenOption)")
            chosenSaved = true

        }
        
    }
    
    func populateChosenOption() {
        if feed != nil {
            for item in feed! {
                print("======Populating Checked Option Array======")
                let poyo = item
                
                var userID = PFUser.currentUser()
                
                var options1Array = poyo["option1Answers"] as! [String]
                
                //                print(options1Array)
                if options1Array.contains({$0 == userID!.objectId}){
                    print("Already answered 1")
                                    chosenOption.append(1)
                    continue
                }
                
                
                
                var options2Array = poyo["option2Answers"] as! [String]
                
                //                print(options2Array)
                
                if options2Array.contains({$0 == userID!.objectId}){
                    print("Already answered 2")
                                    chosenOption.append(2)
                    continue
                }
                print("None answered")
                            chosenOption.append(0)
            }
            
            print("Chosen Option: \(chosenOption)")
        } else {
            print("Chosen did not occur!")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh(sender: AnyObject) {
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20


        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {


                self.feed = media
                self.tableView.reloadData()
                //print(self.feed!)
                // do something with the data fetched

                //                self.refreshControl?.endRefreshing()
            } else {
                //                self.refreshControl?.endRefreshing()
                // handle error
            }


        }
        
    }



    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feed = feed {
            //print(self.feed!.count)
            //            print(feed.count)
            return feed.count

        } else {
            //print("0")
            return 0
        }
    }
    
    
    func checkAnswered (indexPath: NSIndexPath) -> Int {
//        print("CHECKED ANSWERED \(indexPath.row)")
        
//
//        
//        let query : PFQuery = PFQuery(className: "PoyosAnswers")
//        
//        var savedNum: Int = 0;
//        
//        
//        
//        //        query.whereKey("option1Answers", notEqualTo: (PFUser.currentUser()?.objectId)!)
//        
//        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
//            for object in objects! {
//                print("Checked options 1")
//                var cleanArray = object["option1Answers"] as! [String]
//                print(cleanArray)
//                
//                cleanArray = cleanArray.filter() {$0 == PFUser.currentUser()?.objectId}
//                print(cleanArray)
//                
//                
//                print("Checked options 2")
//                
//                var clean2Array = object["option2Answers"] as! [String]
//                print(clean2Array)
//                
//                clean2Array = clean2Array.filter() {$0 == PFUser.currentUser()?.objectId}
//                print(clean2Array)
//                
//                
//                if cleanArray.count > 0 {
//                    print("RETURNING CHECKED ANSWER 1")
//                    savedNum = 1
//                } else if clean2Array.count > 0 {
//                    print("RETURNING CHECKED ANSWER 2")
//                    savedNum = 2
//                } else {
//                    print("RETURNING CHECKED ANSWER 0")
//                    savedNum = 0
//                }
//                //                object["option1Answers"] = object["option1Answers"].filter() { $0 !== PFUser.currentUser()?.objectId } as! [String]
//                
//                
//                
//            }
//            
//            //            print("HERE ARE THE OBJECTS")
//            //            print(objects)
//            
//        }
//        
//        
////        tableView.reloadData()
//
//        return savedNum
//        
//        
        
        
        
                print("===Checking Answer for Index Row: \(indexPath.row)")
                let poyo = self.feed![indexPath.row]
        
        
        
                var userID = PFUser.currentUser()
        
        
        
        
                var options1Array = poyo["option1Answers"] as! [String]
        
//                print(options1Array)
                if options1Array.contains({$0 == userID!.objectId}){
                    print("Already answered 1")
                    return 1
                }
        
        
        
                var options2Array = poyo["option2Answers"] as! [String]
        
//                print(options2Array)
        
                if options2Array.contains({$0 == userID!.objectId}){
                    print("Already answered 2")
                    return 2
                }
                print("None answered")
                return 0
    }
    


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListedPoyoViewCell", forIndexPath: indexPath) as! ListedPoyoViewCell


        let poyo = self.feed![indexPath.row]

        let question = poyo["caption"] as! String
        let option1 = poyo["optionOne"] as! String
        let option2 = poyo["optionTwo"] as! String
        let poyoLatitude = poyo["latitude"].doubleValue as! CLLocationDegrees
        let poyoLongitude = poyo["longitude"].doubleValue as! CLLocationDegrees



        var poyoLocation = CLLocation(latitude: poyoLatitude, longitude: poyoLongitude)
        var distanceFromPoyo: CLLocationDistance = location.distanceFromLocation(poyoLocation)



        cell.distanceLabel.text = String(format: "%.2f meters", distanceFromPoyo)

        if radius < distanceFromPoyo {
            //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)

            //            tableV
        }

        cell.alreadyAnswered = chosenOption[indexPath.row]

//        cell.alreadyAnswered = checkAnswered(indexPath)
//        NSThread.sleepForTimeInterval(2)

        print("alreadyAnswered Value: \(cell.alreadyAnswered)")
        if(cell.alreadyAnswered == 0){
            cell.backgroundColor = UIColor.clearColor()
            cell.option1Button.backgroundColor = UIColor.clearColor()
            cell.option2Button.backgroundColor = UIColor.clearColor()
        } else if cell.alreadyAnswered == 1 {
            cell.backgroundColor = UIColor.greenColor()
            cell.option1Button.backgroundColor = UIColor.greenColor()
            cell.option2Button.backgroundColor = UIColor.clearColor()
        } else {
            cell.backgroundColor = UIColor.blueColor()
            cell.option1Button.backgroundColor = UIColor.clearColor()
            cell.option2Button.backgroundColor = UIColor.blueColor()
        }
        
        


        cell.questionLabel.text = question
        cell.option1Button.setTitle(option1, forState: UIControlState.Normal)
        cell.option2Button.setTitle(option2, forState: UIControlState.Normal)
        
        cell.option1Button.tag = indexPath.row
        cell.option2Button.tag = indexPath.row
        
        cell.option1Button.option = 1
        cell.option2Button.option = 2
        
        cell.option1Button.indexPath = indexPath
        cell.option2Button.indexPath = indexPath
        
        cell.option1Button.chosenItem = cell.alreadyAnswered
        cell.option2Button.chosenItem = cell.alreadyAnswered

        
        

        cell.option1Button.addTarget(self, action: "option1Pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.option2Button.addTarget(self, action: "option1Pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        


        return cell
    }

    
    func deleteAnswers (sender: subclassedUIButton) {
        print("DELETE ANSWERS STARTED")
        let poyo = self.feed![sender.tag]

        
        let query : PFQuery = PFQuery(className: "PoyosAnswers")
        
        query.whereKey("objectId", equalTo: poyo.objectId!)

        
        
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
                print("Remove options")
                var cleanArray = object["option1Answers"] as! [String]
                print(cleanArray)
                
                cleanArray = cleanArray.filter() {$0 != PFUser.currentUser()?.objectId}
                print(cleanArray)
                
                object["option1Answers"] = cleanArray
                
                
                
                var clean2Array = object["option2Answers"] as! [String]
                print(cleanArray)
                
                clean2Array = clean2Array.filter() {$0 != PFUser.currentUser()?.objectId}
                print(cleanArray)
                
                object["option2Answers"] = clean2Array
                
                object.saveInBackground()
//                object["option1Answers"] = object["option1Answers"].filter() { $0 !== PFUser.currentUser()?.objectId } as! [String]
                
            

            }
            print("HERE ARE THE OBJECTS: \(objects)")
//            print(objects)
            
        }
        
        reloadAllData()

        

        
    }

    func option1Pressed(sender: subclassedUIButton!) {
//        let buttonTag = sender.tag
        let point = tableView.convertPoint(CGPoint.zero, fromView: sender)
        
        guard let foundIndexPath = tableView.indexPathForRowAtPoint(point) else {
            fatalError("can't find point in tableView")
        }
        
        print("THIS IS THE INDEX PATH")
        print(foundIndexPath.row)
        
        var cell = tableView.cellForRowAtIndexPath(foundIndexPath) as! ListedPoyoViewCell
        
        
        var pickedButtonId = 0
        
        let poyo = self.feed![sender.tag]
        
        pickedButtonId = sender.option!
        
        
        print("pickedButtonID: \(pickedButtonId)")
        print("Button's chosenItem \(sender.chosenItem)")
        
        if pickedButtonId == sender.chosenItem {
            print("Already chosen this option")
            return
        } else if sender.chosenItem != 0 {
            print("Option 1 Attempted to be deleted")
            deleteAnswers(sender)
        } else {
            print("Error: It messed up")
            print(sender.chosenItem)

        }


        print("ITTWERKS!!!")
        var query = PFQuery(className: "PoyosAnswers")
        var poyoID = poyo.objectId
        var userID = PFUser.currentUser()
        
        query.getObjectInBackgroundWithId(poyoID!) { (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let object = object {
                switch pickedButtonId {
                    case 1:
                        print("Option 1 Done")
                        
        

                        object.addObject(PFUser.currentUser()!.objectId!, forKey: "option1Answers")
//                        self.addNewPresetDecision(sender.indexPath!, chosenOption: 1)
                        sender.chosenItem = 1
                        cell.alreadyAnswered = 1
                        cell.option2Button.chosenItem = 1
                        
                        self.chosenOption[sender.tag] = 1
                    
                        self.tableView.reloadData()

                    case 2:
                        print("Option 2 Done")

                        object.addObject(PFUser.currentUser()!.objectId!, forKey: "option2Answers")

//                        self.addNewPresetDecision(sender.indexPath!, chosenOption: 2)
                        
                        sender.chosenItem = 2
                        cell.alreadyAnswered = 2

                        cell.option1Button.chosenItem = 2
                        
                        self.chosenOption[sender.tag] = 2

                        self.tableView.reloadData()

                    default:
                        print("None chosen")

                }

            }
            
//            self.checkAnswered(sender.indexPath!)
            
            self.reloadAllData()

            object?.saveInBackground()
        }
        
        cell.alreadyAnswered = pickedButtonId
        self.tableView.reloadRowsAtIndexPaths([foundIndexPath], withRowAnimation: UITableViewRowAnimation.None)
        tableView.cellForRowAtIndexPath(foundIndexPath)
        tableView.reloadData()
        print("==========================")
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }

        var indexPaths : Array<NSIndexPath> = []

        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }

        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.None)
        }

    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! ListedPoyoViewCell).watchFrameChanges()
    }

    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! ListedPoyoViewCell).ignoreFrameChanges()

    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return ListedPoyoViewCell.expandedHeight
        } else {
            return ListedPoyoViewCell.defaultHeight
        }
    }


    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var latestLocation: AnyObject = locations[locations.count - 1]

        //        latitudeLabel.text = String(format: "%.4f", latestLocation.coordinate.latitude)
        //        longitudeLabel.text = String(format: "%.4f", latestLocation.coordinate.longitude)

        if location == nil {
            location = latestLocation as! CLLocation
        }



        var kennedy = CLLocation(latitude: 28.572646, longitude: -80.649024)
        var distanceFromKennedy: CLLocationDistance = location.distanceFromLocation(kennedy)
        var distanceMiles = distanceFromKennedy * 0.621371 / 1000
        //
        //        kennedyDistLabel.text = String(format: "%.2f meters", distanceFromKennedy)
        //
        //        rocketMiles.text = String(format: "%.2f miles", distanceMiles)

    }

    @IBAction func resetLocation(sender: AnyObject) {
        location = nil
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

class subclassedUIButton: UIButton {
    var indexPath: NSIndexPath?
    var chosenItem: Int?
    var option: Int?
    var urlString: String?
}