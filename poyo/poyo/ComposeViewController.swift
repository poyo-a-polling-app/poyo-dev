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

class ComposeViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var optionTwoCounter: UILabel!
    @IBOutlet weak var optionOneCounter: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var poyoField: UITextField!
    @IBOutlet weak var optionOneLabel: UITextField!
    @IBOutlet weak var optionTwoLabel: UITextField!
    @IBOutlet weak var timeLimit: UITextField!

    @IBOutlet weak var imageOneView: UIImageView!
    @IBOutlet weak var imageTwoView: UIImageView!
    
    var locationManager = CLLocationManager()
    var location: CLLocation!

    var longitudeLabel = ""
    var latitudeLabel = ""

    var timer = "";
    
    var limitLength = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
        poyoField.delegate = self
        optionOneLabel.delegate = self
        optionTwoLabel.delegate = self

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

        var timer =  NSTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "characterCounter", userInfo: nil, repeats: true)
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

    }


    @IBAction func onPost(sender: AnyObject) {
        let secondsLeftInt = Int(myDatePicker.date.timeIntervalSinceNow)
        //let secondsLeftString = secondsLeftInt as! String
        performSegueWithIdentifier("Postlist", sender: nil)
        UserMedia.postPoyo(withCaption: poyoField.text, withCaption: longitudeLabel, withCaption: latitudeLabel, withCaption: optionOneLabel.text, withCaption: optionTwoLabel.text, withCaption: String(secondsLeftInt), withCompletion: nil)
        print("did something send?")
    }
    
    func characterCounter() {
        var characterCount = poyoField.text!.characters.count
        var characterOneCount = optionOneLabel.text!.characters.count
        var characterTwoCount = optionTwoLabel.text!.characters.count
        
        var charactersLeft = 80 - characterCount
        var charactersOneLeft = 40 - characterOneCount
        var charactersTwoLeft = 40 - characterTwoCount
        
        countLabel.text = String(charactersLeft)
        optionOneCounter.text = String(charactersOneLeft)
        optionTwoCounter.text = String(charactersTwoLeft)
        
        //caption counter color
        if charactersLeft < 10 {
            countLabel.textColor = UIColor.redColor()
        }
        else if charactersLeft >= 10 {
            countLabel.textColor = UIColor.grayColor()
        }
        
        //option 1 counter color
        if charactersOneLeft < 10 {
            optionOneCounter.textColor = UIColor.redColor()
        }
        else if charactersOneLeft >= 10 {
            optionOneCounter.textColor = UIColor.grayColor()
        }
        
        //option 2 counter color
        if charactersTwoLeft < 10 {
            optionTwoCounter.textColor = UIColor.redColor()
        }
        else if charactersTwoLeft >= 10 {
            optionTwoCounter.textColor = UIColor.grayColor()
        }
        
        
        //delete if past 0 characters
        if charactersLeft < 0 {
            poyoField.deleteBackward()
        }
        if charactersOneLeft < 0 {
            optionOneLabel.deleteBackward()
        }
        if charactersTwoLeft < 0 {
            optionTwoLabel.deleteBackward()
        }
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
