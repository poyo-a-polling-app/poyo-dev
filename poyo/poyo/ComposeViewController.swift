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

class ComposeViewController: UIViewController, CLLocationManagerDelegate {
    
    var imageTwo: UIImage?
    var imageOne: UIImage?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false

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
        self.imageOneView.image = nil
        self.imageTwoView.image = nil
        
        print(imageOneView.image)
        print(imageTwoView.image)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(imageOneView.image)
        print(imageTwoView.image)
    }
    
    override func viewWillAppear(animated: Bool) {
        imageTwoView.image = imageTwo
        imageOneView.image = imageOne
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

    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        PFUser.logOutInBackground()
        self.performSegueWithIdentifier("LogoutSegue", sender: nil)
    }
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    @IBAction func onImageOne(sender: AnyObject) {
        let imageoneView = ImageOneView()
        
        //self.navigationController?.pushViewController(imageoneView, animated: true)
        // Closures :)
        /*imageoneView.onDataAvailable = {[weak self]
            (data: UIImage) in
            self!.imageOneView.image = data
            print(self!.imageOneView.image)
        }*/
        print("hello Mutha")
        self.presentViewController(imageoneView, animated: true, completion: nil)
    }
    
     @IBAction func onImageTwo(sender: AnyObject) {
        performSegueWithIdentifier("ImageTwoer", sender: nil)
     }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }

}
