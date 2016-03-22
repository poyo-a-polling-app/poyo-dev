//
//  ProfileViewController.swift
//  poyo
//
//  Created by Shakeeb Majid on 3/15/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var tableview: UITableView!
    var user: PFUser?
    var poyos: [PFObject]?

    var locationManager = CLLocationManager()
    var location: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self

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


        user = PFUser.currentUser()
        print("User: \(user)")
        var query = PFQuery(className: "Poyos")
        //query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.currentUser()!)



        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in

            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                self.poyos = []
                // Do something with the found objects
                if let objects = objects {

                    for object in objects {
                        let date = object["time"] as! NSDate

                        let timeElapsed = Int(0 - date.timeIntervalSinceNow)
                        if(timeElapsed > 60 * 60 * 21) {
                            UserMedia.killPoyo(object)
                            objects
                        } else {
                            self.poyos!.append(object)
                        }


                        print(object.objectId)

                    }

                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.tableview.reloadData()
        }



        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let poyos = poyos {
            return poyos.count
        } else {
            return 0
        }

    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ListedPoyoViewCell

        var poyo = poyos![indexPath.row] as! PFObject
        let date = poyo["time"] as! NSDate


        cell.questionLabel.text = poyo["caption"] as! String
        cell.votesLabel.text = "800"
        cell.timeLabel.text = timeElapsed(date)

        let poyoLatitude = poyo["latitude"].doubleValue as! CLLocationDegrees
        let poyoLongitude = poyo["longitude"].doubleValue as! CLLocationDegrees



        var poyoLocation = CLLocation(latitude: poyoLatitude, longitude: poyoLongitude)
        var distanceFromPoyo: CLLocationDistance = location.distanceFromLocation(poyoLocation)



        cell.distanceLabel.text = String(format: "%.2f meters", distanceFromPoyo)


        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.editButtonItem().title = "Close"
            var something = tableview.cellForRowAtIndexPath(indexPath) as! ListedPoyoViewCell
            something.killCell()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
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



    func timeElapsed(date: NSDate) -> String {

        let timeElapsed = Int(0 - date.timeIntervalSinceNow)
        print(timeElapsed)

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

}
