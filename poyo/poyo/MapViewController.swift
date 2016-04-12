//
//  MapViewController.swift
//  poyo
//
//  Created by Shakeeb Majid on 4/12/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(poyoLat, poyoLong), MKCoordinateSpanMake(0.01, 0.01))
            mapView.delegate = self
            
            mapView.setRegion(sfRegion, animated: false)
            
            let sanFranLocation = CLLocationCoordinate2DMake(poyoLat, poyoLong)
            //let pin = MKPinAnnotationView()
            //pin.pinColor = .Green
            
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = sanFranLocation
            dropPin.title = "San Francisco"
            mapView.addAnnotation(dropPin)
            
        }
        
        var query = PFQuery(className: "PoyosAnswers")
        //query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        
        
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    
                    for object in objects {
                        let date = object["time"] as! NSDate
                        
                        let timeElapsed = Int(0 - date.timeIntervalSinceNow)
                        if(timeElapsed > 60 * 60 * 21) {
                            UserMedia.killPoyo(object)
                            objects
                        } else {
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
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
          
        }
        
        var query1 = PFQuery(className: "PoyoGrave")
        //query.includeKey("author")
        query1.whereKey("author", equalTo: PFUser.currentUser()!)
        
        query1.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                
                // Do something with the found objects
                if let objects = objects {
                    
                    for object in objects {
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
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        
        }


        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
