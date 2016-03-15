//
//  ComposeViewController.swift
//  poyo
//
//  Created by Kevin Asistores on 3/8/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class ComposeViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var poyoField: UITextField!
    @IBOutlet weak var optionOneLabel: UITextField!
    @IBOutlet weak var optionTwoLabel: UITextField!
    
    var locationManager = CLLocationManager()
    var location: CLLocation!
    
    var longitudeLabel = ""
    var latitudeLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //Make a change make a wish
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var latestLocation: AnyObject = locations[locations.count - 1]
        
        latitudeLabel = String(format: "%.4f", latestLocation.coordinate.latitude)
        longitudeLabel = String(format: "%.4f", latestLocation.coordinate.longitude)
        
        if location == nil {
            location = latestLocation as! CLLocation
        }
        
        /*
        
        var kennedy = CLLocation(latitude: 28.572646, longitude: -80.649024)
        var distanceFromKennedy: CLLocationDistance = location.distanceFromLocation(kennedy)
        var distanceMiles = distanceFromKennedy * 0.621371 / 1000
        
        kennedyDistLabel.text = String(format: "%.2f meters", distanceFromKennedy)
        
        rocketMiles.text = String(format: "%.2f miles", distanceMiles)
        */
        
    }
    
    
    @IBAction func onPost(sender: AnyObject) {
        UserMedia.postPoyo(withCaption: poyoField.text, withCaption: longitudeLabel, withCaption: latitudeLabel, withCaption: optionOneLabel.text, withCaption: optionTwoLabel.text, withCompletion: nil)
        print("did something send?")
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        PFUser.logOutInBackground()
        self.performSegueWithIdentifier("LogoutSegue", sender: nil)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
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

