
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


    var feed: [PFObject]?

    var radius: CLLocationDistance = 100

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

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

        let query = PFQuery(className:"Poyos")
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {


                //                self.feed = media
                //                self.tableView.reloadData()
                print(media)
                self.feed = media
                self.tableView.reloadData()
                // do something with the data fetched
            } else {
                // handle error
            }
        }

        //        query.getObjectInBackgroundWithId("xWMyZEGZ") {
        //            (gameScore: PFObject?, error: NSError?) -> Void in
        //            if error == nil && gameScore != nil {
        //                print(gameScore)
        //            } else {
        //                print(error)
        //            }
        //        }





        // Do any additional setup after loading the view.
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


        cell.questionLabel.text = question
        cell.option1Button.setTitle(option1, forState: UIControlState.Normal)
        cell.option2Button.setTitle(option2, forState: UIControlState.Normal)
        
        cell.option1Button.tag = indexPath.row
//        print(cell.option1Button.tag)
        cell.option2Button.tag = indexPath.row


        cell.option1Button.addTarget(self, action: "option1Pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.option2Button.addTarget(self, action: "option1Pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        


        return cell
    }
    
    func option1Pressed(sender: UIButton!) {
//        let buttonTag = sender.tag
        var pickedButtonId = 0
        let poyo = self.feed![sender.tag]
        if let buttonTitle = sender.titleLabel?.text {
            print(buttonTitle)
            if poyo["optionOne"] as! String == buttonTitle {
                pickedButtonId = 1
            } else {
                pickedButtonId = 2
            }
        }
        
        print(pickedButtonId)


        print("ITTWERKS!!!")
        var query = PFQuery(className: "Poyos")
        var userID = poyo.objectId
        print(userID)
        
        query.getObjectInBackgroundWithId(userID!) { (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let object = object {
                switch pickedButtonId {
                    case 1:
                        print("Option 1 Done")
//                        object.addObject(PFUser.currentUser()!, forKey: "option1Answers")
                    case 2:
                        print("Option 2 Done")
                    default:
                        print("None chosen")

                }

            }
            

            object?.saveInBackground()
        }
    }
    
    func option2Pressed(sender: UIButton!) {
        //        let buttonTag = sender.tag
        let poyo = self.feed![sender.tag]
        
        print("ITTWERKS!!!")
        var query = PFQuery(className: "Poyos")
        var userID = poyo.objectId
        print(userID)
        
        query.getObjectInBackgroundWithId(userID!) { (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let object = object {
                object.addObject(PFUser.currentUser()!, forKey: "option2Answers")
            }
            
            object?.saveInBackground()
        }
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
