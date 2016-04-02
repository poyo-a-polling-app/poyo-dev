
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

    var chosenOption = [poyoChosen]()
    
    var currentUserAnswer = [Int]()

<<<<<<< HEAD
=======
    var refreshControl: UIRefreshControl?

>>>>>>> develop
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        
        self.locationManager.requestAlwaysAuthorization()

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
<<<<<<< HEAD
=======
        tableView.reloadData()
        

        
    }
    
    func refresh(sender: AnyObject) {
        
        chosenSaved = false
        reloadAllData()
        print("hey after reload all data ")
        
        //tableView.reloadData()
        self.refreshControl?.endRefreshing()
        
>>>>>>> develop
    }
    
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false

        reloadAllData()
        populateChosenOption()

    }
    
    override func viewDidAppear(animated: Bool) {
    }

    func reloadAllData() {
        //print("RELOADING DATA!!!")
        
    

        let query = PFQuery(className:"Poyos")
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                self.feed = []
                

                for (index, medium) in media.enumerate() {
                    if index >= self.chosenOption.count {
                        print("Extra option has been created \(self.chosenOption.count) ++++++++++++++++++++++++++++++++++++++++++++++")
                        self.chosenOption.append(poyoChosen(poyoObjectID: "0", chosenNumber: 0))
                    }
                    print("hey work you piece of shit \(index)")
                    let timeLimit = Int(medium["timeLimit"] as! String)
                    let date = medium["time"] as! NSDate
                    let timeElapsed = Int(0 - date.timeIntervalSinceNow)
                    if(timeElapsed > timeLimit!) {
                        UserMedia.killPoyo(medium)
                    } else {
                        //print("hey you yeah you")
                        self.feed!.append(medium)
                        if !self.chosenSaved {
                            print("Populated the Chosen Option Array!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                            self.populateChosenOption()

                        } else {
                            print("POPULATED DID NOT HAPPEN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                            
                        }
                    }

                }
                //                self.feed = media
                //                self.tableView.reloadData()
                print(media)
                self.tableView.reloadData()
                // do something with the data fetched
                print("IT ACCESSED THE DATA!!!!!")
            } else {
                print("COULD NOT ACCESS THE DATA")

                // handle error
            }


        }
        
        if chosenOption.count != 0 {
            //print("Chosen saved: \(chosenOption)")
            chosenSaved = true
            
        }
 
        
    }

    func populateChosenOption() {
        var tempArray = [poyoChosen]()
        if feed != nil {
            for item in feed! {
                print("======Populating Checked Option Array======")
                let poyo = item

                var userID = PFUser.currentUser()

                var options1Array = poyo["option1Answers"] as! [String]

                //                print(options1Array)
                if options1Array.contains({$0 == userID!.objectId}){
                    print("Already answered 1")
                    let newPoyoChosen = poyoChosen(poyoObjectID: userID!.objectId!, chosenNumber: 1)
                    tempArray.append(newPoyoChosen)
                    continue
                }



                var options2Array = poyo["option2Answers"] as! [String]

                //                print(options2Array)

                if options2Array.contains({$0 == userID!.objectId}){
                    print("Already answered 2")
                    let newPoyoChosen = poyoChosen(poyoObjectID: userID!.objectId!, chosenNumber: 2)
                    tempArray.append(newPoyoChosen)
                    continue
                }
                print("None answered")
                    tempArray.append(poyoChosen(poyoObjectID: "0", chosenNumber: 0))
            }

            chosenOption = tempArray

            print("Chosen Option: \(chosenOption)")
        } else {
            print("Chosen did not occur!")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   /* func refresh(sender: AnyObject) {
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

    } */



    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feed = feed {
            print("FEED COUNT: \(feed.count)")
            return feed.count
        } else {
            return 0
        }
    }

    func countVotes(indexPath: NSIndexPath, option: Int) -> Int {
        let poyo = self.feed![indexPath.row]
        var chosen1vote = 0
        var chosen2vote = 0
        if chosenOption[indexPath.row].recentVote == 1 {
            chosen1vote = 1
        } else if chosenOption[indexPath.row].recentVote == 2 {
            chosen2vote = 1
        }
        switch option {
            case 1:
                if poyo["option1Answers"].count == 1 && chosen1vote == 1 {
                    return 1
                } else if poyo["option1Answers"].count == 1 && chosen2vote == 1{
                    return 0
                } else {
                    return poyo["option1Answers"].count + chosen1vote
                }
     
            case 2:
                if poyo["option2Answers"].count == 1 && chosen2vote == 1 {
                    return 1
                } else if poyo["option2Answers"].count == 1 && chosen1vote == 1{
                    return 0
                } else {
                    return poyo["option2Answers"].count + chosen2vote
                }
            default:
                return 0
        }
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListedPoyoViewCell", forIndexPath: indexPath) as! ListedPoyoViewCell
        
        let poyo = self.feed![indexPath.row]
        
        cell.poyo = poyo
        let date = poyo["time"] as! NSDate
        let question = poyo["caption"] as! String
        let option1 = poyo["optionOne"] as! String
        let option2 = poyo["optionTwo"] as! String
        let poyoLatitude = poyo["latitude"].doubleValue as! CLLocationDegrees
        let poyoLongitude = poyo["longitude"].doubleValue as! CLLocationDegrees
        print("0hey i reached this point \(indexPath.row)")


        var poyoLocation = CLLocation(latitude: poyoLatitude, longitude: poyoLongitude)
        var distanceFromPoyo: CLLocationDistance = location.distanceFromLocation(poyoLocation)



        cell.distanceLabel.text = String(format: "%.2f meters", distanceFromPoyo)

        if radius < distanceFromPoyo {
            //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)

            //            tableV
        }
        print("1hey i reached this point \(indexPath.row)")
        cell.alreadyAnswered = chosenOption[indexPath.row].chosen!
        print("2hey i reached this point \(indexPath.row)")

//        NSThread.sleepForTimeInterval(2)
        
        //print("alreadyAnswered Value: \(cell.alreadyAnswered)")
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
        var votesOneCount = CGFloat(countVotes(indexPath, option: 1))
        var votesTwoCount = CGFloat(countVotes(indexPath, option: 2))
        print("1hey i reached this point \(indexPath.row)")
        
        cell.votesOne.text = String(format: "\(Int(votesOneCount))")
        cell.votesTwo.text = String(format: "\(Int(votesTwoCount))")

        
        
    // MARK: EDITING LIVE RESULTS
    //calculating total votes
        
        cell.voteOverlayOne.userInteractionEnabled = false;
        cell.voteOverlayTwo.userInteractionEnabled = false;

        var totalCount = Int(votesOneCount + votesTwoCount)

        if totalCount == 1 {
            cell.votesLabel.text = String(format: "\(totalCount) vote")
        } else {
            cell.votesLabel.text = String(format: "\(totalCount) votes")
        }
    //calculating percentage of votes
        var votesOnePercent = CGFloat(votesOneCount/(votesOneCount + votesTwoCount))
        var votesTwoPercent = CGFloat(votesTwoCount/(votesOneCount + votesTwoCount))
        
        var voteOneHeight = 25 * votesOnePercent
        var voteTwoHeight = 25 * votesTwoPercent
        
        //print("votesOnePercent: \(votesOnePercent)")
        //print("votesTwoPercent: \(votesTwoPercent)")
        
//        cell.voteOverlayOne.layer.anchorPoint = CGPointMake(0.5, 1)
        
//        cell.voteOverlayOne.frame.height / 2
        
//            cell.voteOverlayOne.frame.origin.y = CGFloat(25)
        
//
//        transformation = CGAffineTransformTranslate(transformation, 0, 100)
//                NSThread.sleepForTimeInterval(2)
        
//        UIView.animateWithDuration(0.6 ,
//            animations: {
//                cell.voteOverlayOne.transform = CGAffineTransformMakeScale(1,votesOnePercent)
//            },
//            completion: { finish in
//                UIView.animateWithDuration(0.6){
//                    cell.voteOverlayOne.transform = CGAffineTransformIdentity
//                }
//        })
//        
        cell.voteOverlayOne.transform = CGAffineTransformMakeScale(1,votesOnePercent)

        cell.voteOverlayTwo.transform = CGAffineTransformMakeScale(1,votesTwoPercent)
        
        // MARK: CELL EDITING
        
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

        cell.timeLabel.text = timeElapsed(date)
<<<<<<< HEAD
        cell.seeComments.tag = indexPath.row

=======
        
        print("HEY THIS SHIT WORKED")
>>>>>>> develop
        return cell
    }



    func deleteAnswers (indexPath: NSIndexPath) {
        print("DELETE ANSWERS STARTED")
        let poyo = self.feed![indexPath.row]


        let query : PFQuery = PFQuery(className: "PoyosAnswers")

        query.whereKey("objectId", equalTo: poyo.objectId!)


        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
                print("Remove options")
                
                //Deleting from Option 1
                var cleanArray = object["option1Answers"] as! [String]
                print(cleanArray)

                cleanArray = cleanArray.filter() {$0 != PFUser.currentUser()?.objectId}
                print(cleanArray)

                object["option1Answers"] = cleanArray

                //Deleting from Option 2
                var clean2Array = object["option2Answers"] as! [String]
                print(cleanArray)

                clean2Array = clean2Array.filter() {$0 != PFUser.currentUser()?.objectId}
                print(cleanArray)

                object["option2Answers"] = clean2Array

                //Saving the Parse into the background
                object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if let error = error {
                        print("Votes was not deleted Failed")
                        print(error.localizedDescription)
                        
                    } else {
                        print("Vote was deleted successfully")
                        self.navigationController?.popViewControllerAnimated(true)
                        self.reloadAllData()
                        self.tableView.reloadData()
                    }
                }
            }
           
            print("HERE ARE THE OBJECTS: \(objects)")
//            print(objects)

        }

//        reloadAllData()




    }
    
    func addChosenToParse(indexPath: NSIndexPath) {
        
        print("########ADDING THE OPTIONS TO PARSE##########")
        
        let poyo = self.feed![indexPath.row]
        
        let query : PFQuery = PFQuery(className: "PoyosAnswers")
        
        
        query.whereKey("objectId", equalTo: poyo.objectId!)
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
                print("ADDING THE NEW VOTES!")
                
                print("Remove options")
                
                //Deleting from Option 1
                var cleanArray = object["option1Answers"] as! [String]
                print(cleanArray)
                
                cleanArray = cleanArray.filter() {$0 != PFUser.currentUser()?.objectId}
                print(cleanArray)
                
                object["option1Answers"] = cleanArray
                
                //Deleting from Option 2
                var clean2Array = object["option2Answers"] as! [String]
                print(cleanArray)
                
                clean2Array = clean2Array.filter() {$0 != PFUser.currentUser()?.objectId}
                print(cleanArray)
                
                object["option2Answers"] = clean2Array
            
                print(self.chosenOption[indexPath.row])
                switch self.chosenOption[indexPath.row].chosen! {
                    case 1:

                        var newArray = object["option1Answers"] as! [String]
                        print(newArray)
                        print("Option 1 Done")
                        newArray.append(PFUser.currentUser()!.objectId!)
                        object["option1Answers"] = newArray
                    case 2:

                        var newArray = object["option2Answers"] as! [String]
                        print(newArray)
                        print("Option 2 Done")
                        newArray.append(PFUser.currentUser()!.objectId!)
                        object["option2Answers"] = newArray

                    default:
                        print("None chosen")
                }

                object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if let error = error {
                        print("Votes was not counted Failed")
                        print(error.localizedDescription)

                    } else {
                        print("Vote was added successfully")
                        self.navigationController?.popViewControllerAnimated(true)
                        self.reloadAllData()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    func option1Pressed(sender: subclassedUIButton!) {

        var cell = tableView.cellForRowAtIndexPath(sender.indexPath!) as! ListedPoyoViewCell

        var pickedButtonId = 0

        let poyo = self.feed![sender.tag]

        pickedButtonId = sender.option!

        print("pickedButtonID: \(pickedButtonId)")
        print("Button's chosenItem \(sender.chosenItem)")

        if pickedButtonId == sender.chosenItem {
            print("Already chosen this option")
            return
        } else if sender.chosenItem != 0 {
            print("OPTIONS Attempted to be deleted")
        } else {
            print("Error: It messed up")
            print(sender.chosenItem)
        }
  
        switch pickedButtonId {
        case 1:
            print("Option 1 Done")
            self.chosenOption[sender.tag].chosen = 1
            self.chosenOption[sender.tag].recentVote = 1
            
        case 2:
            print("Option 2 Done")
            self.chosenOption[sender.tag].chosen = 2
            self.chosenOption[sender.tag].recentVote = 2
            
        default:
            print("None chosen")
            
        }
        
        tableView.reloadData()
        cell.alreadyAnswered = pickedButtonId

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
            addChosenToParse(indexPath)

        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }

        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
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

    func timeElapsed(date: NSDate) -> String {

        let timeElapsed = Int(0 - date.timeIntervalSinceNow)
        //print("timeElapsed \(timeElapsed)")

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


//    @IBAction func seeCommentsPressed(sender: AnyObject) {
//        self.performSegueWithIdentifier("commentsSection", sender: sender)
//    }
    
//     MARK: - Navigation
//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as! CommentsViewController
//        var indexPath = tableView.indexPathForCell(sender)
//        var buttonNew = sender
        
        
//        print(buttonNew)
        print(sender!.tag)
        let passPoyo = feed![sender!.tag]

        vc.passedPoyo = passPoyo
    }
 

}

class subclassedUIButton: UIButton {
    var indexPath: NSIndexPath?
    var chosenItem: Int?
    var option: Int?
    var urlString: String?
}

<<<<<<< HEAD
//class comment{
//    var commentString: String?
//    var user: PFUser?
//    var timeStamp: NSDate?
//}
=======
class poyoChosen {
    var poyoID: String?
    var chosen: Int?
    var recentVote: Int?
    
    init(poyoObjectID: String, chosenNumber: Int) {
        poyoID = poyoObjectID
        chosen = chosenNumber
        recentVote = 0
    }
}
>>>>>>> develop
