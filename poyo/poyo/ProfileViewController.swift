//
//  ProfileViewController.swift
//  poyo
//
//  Created by Shakeeb Majid on 3/15/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import Parse
import MapKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var tableview: UITableView!

    @IBOutlet weak var poyoCount: UILabel!

    @IBOutlet weak var voteCount: UILabel!

    @IBOutlet weak var ageCount: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var user: PFUser?
    var poyos: [PFObject]?
    var graves: [PFObject]?
    var locationManager = CLLocationManager()
    var location: CLLocation!
    var poyoCounter = 0
    var voteCounter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        mapView.delegate = self

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"


        /*find out and place date format from http://userguide.icu-project.org/formatparse/datetime
         */
        let createdAt = PFUser.currentUser()!.createdAt!
        print("sdfsdkfljf........\(createdAt)")

        let timeElapsedString = timeElapsed(createdAt)

        ageCount.text = timeElapsedString


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


        var locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()

        var currentLocation = CLLocation!()

        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized){

            currentLocation = locManager.location

            print("longitude: \(currentLocation.coordinate.longitude)")
            print("latitude: \(currentLocation.coordinate.latitude)")


            let poyoLat = currentLocation.coordinate.latitude

            let poyoLong = currentLocation.coordinate.longitude



            let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(poyoLat, poyoLong), MKCoordinateSpanMake(0.1, 0.1))



            mapView.setRegion(sfRegion, animated: false)

             let sanFranLocation = CLLocationCoordinate2DMake(poyoLat, poyoLong)
             //let pin = MKPinAnnotationView()
             //pin.pinColor = .Green

             let dropPin = MKPointAnnotation()
             dropPin.coordinate = sanFranLocation
             dropPin.title = "CurrentLocation"
             mapView.addAnnotation(dropPin)
            

        }


        user = PFUser.currentUser()
        print("User: \(user)")
        var query = PFQuery(className: "PoyosImageTest")
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
                            self.poyoCounter++
                            self.voteCounter += (object["option1Answers"] as! [NSDictionary]).count + (object["option2Answers"] as! [NSDictionary]).count

                            self.poyos!.append(object)

                            let poyoLat = Double(object["latitude"] as! String)

                            let poyoLong = Double(object["longitude"] as! String)

                            let sanFranLocation = CLLocationCoordinate2DMake(poyoLat!, poyoLong!)
                            //let pin = MKPinAnnotationView()
                            //pin.pinColor = .Green

                            let dropPin = MKPointAnnotation()
                            dropPin.coordinate = sanFranLocation
                            dropPin.title = "San Francisco"
                            self.mapView.addAnnotation(dropPin)


                        }


                        print(object.objectId)

                    }
                    self.poyoCount.text = "\(self.poyoCounter)"
                    self.voteCount.text = "\(self.voteCounter)"


                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.tableview.reloadData()
        }

        var query1 = PFQuery(className: "ShakPoyoGrave")
        //query.includeKey("author")
        query1.whereKey("author", equalTo: PFUser.currentUser()!)

        query1.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in

            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                self.graves = []
                // Do something with the found objects
                if let objects = objects {

                    for object in objects {
                        self.poyoCounter++
                        self.voteCounter += (object["option1Answers"] as! [NSDictionary]).count + (object["option2Answers"] as! [NSDictionary]).count

                        //DHFSFHSDFH
                        self.graves!.append(object)

                        let poyoLat = Double(object["latitude"] as! String)

                        let poyoLong = Double(object["longitude"] as! String)

                        let sanFranLocation = CLLocationCoordinate2DMake(poyoLat!, poyoLong!)
                        //let pin = MKPinAnnotationView()
                        //pin.pinColor = .Green

                        let dropPin = MKPointAnnotation()
                        dropPin.coordinate = sanFranLocation
                        dropPin.title = "San Francisco"
                        self.mapView.addAnnotation(dropPin)

                        print(object.objectId)

                    }
                    self.poyoCount.text = "\(self.poyoCounter)"
                    self.voteCount.text = "\(self.voteCounter)"

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
            if let graves = graves {
                print("both count: \(poyos.count + graves.count + 1)")
                return (poyos.count + graves.count + 1)
            } else {
                print("poyos count: \(poyos.count)")
                return poyos.count
            }

        } else if let graves = graves {
            print("graves count: \(graves.count)")

            return graves.count

        } else {
            print("count: 0")

            return 0
        }

    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("ASLKNDLKASNFASKNFNLASKFANSKFNKLAS \(indexPath)")
        
        if let cellEx = tableView.dequeueReusableCellWithIdentifier("Profile-Cell") {
            print("LANSKLFNIASNFILASFIANSIFLNASLIFN")
        }
            else {
            print("lkankfnasfkasnflknas")
            fatalError("unexpected cell dequeued from tableView") }
    

//        var cellExtra = tableView.dequeueReusableCellWithIdentifier("Profile-Cell", forIndexPath: indexPath)
        print("LKANSLKNASNFASKNFNASLFNKALSFKLANSNFA")
//        print(cellEx)



        var cell = tableView.dequeueReusableCellWithIdentifier("Profile-Cell", forIndexPath: indexPath) as! ListedPoyoViewCell


        var poyo: PFObject?
        print("zeroth")
        print("index row: \(indexPath.row)")
        let rowNum = indexPath.row
        if let poyos = self.poyos{
            if rowNum < poyos.count {
                print("first")
                poyo = poyos[rowNum] as! PFObject

            } else if rowNum == poyos.count {
                cell.questionLabel.text = "hey these are your old poyos :]"
                cell.votesLabel.hidden = true
                cell.timeLabel.hidden = true
//                cell.distanceLabel.hidden = true
                print("second")
            } else {

                print("third")
                print("index \(rowNum-poyos.count-1)")
                poyo = graves![rowNum-poyos.count-1]
                //print("infiniti")

            }



        } else if let graves = self.graves {
            poyo = graves[rowNum] as! PFObject
            print("fourth")

        }
        print("fifth")

        if poyo != nil {
            print("sixth")
            let date = poyo!["time"] as! NSDate
            cell.poyo = poyo!
            cell.questionLabel.text = poyo!["caption"] as! String
            cell.votesLabel.text = "800"
            cell.timeLabel.text = timeElapsed(date)
            let poyoLatitude = poyo!["latitude"].doubleValue as! CLLocationDegrees
            let poyoLongitude = poyo!["longitude"].doubleValue as! CLLocationDegrees
            var poyoLocation = CLLocation(latitude: poyoLatitude, longitude: poyoLongitude)
            var distanceFromPoyo: CLLocationDistance = location.distanceFromLocation(poyoLocation)
//            cell.distanceLabel.text = String(format: "%.2f meters", distanceFromPoyo)
        }


        return cell
    }

    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Close"
    }

    /*func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Close"
    } */

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            var something = tableview.cellForRowAtIndexPath(indexPath) as! ListedPoyoViewCell
            something.killCell()
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



    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"

        // custom image annotation
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }

        if annotation.title! == "CurrentLocation" {
            annotationView!.image = UIImage(named: "moose")

        } else {
            annotationView!.image = UIImage(named: "Icon")
        }

        return annotationView
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
