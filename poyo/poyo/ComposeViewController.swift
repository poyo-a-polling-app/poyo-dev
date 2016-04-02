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
    
    @IBOutlet weak var imageOneButton: UIButton!
    @IBOutlet weak var imageTwoButton: UIButton!
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
        
        self.imageOneButton.tag = 1
        self.imageTwoButton.tag = 2
        

        // Do any additional setup after loading the view.
    }
    
    /*override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(imageOneView.image)
        print(imageTwoView.image)
    }*/
    
    override func viewWillAppear(animated: Bool) {
        imageOneView.image = imageOne
        imageTwoView.image = imageTwo
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
        UserMedia.postPoyo(withCaption: poyoField.text, withCaption: longitudeLabel, withCaption: latitudeLabel, withCaption: optionOneLabel.text, withCaption: optionTwoLabel.text, withCaption: String(secondsLeftInt), withCompletion: nil)
        print("did something send?")
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("waht")
        let svc = unwindSegue.sourceViewController as? ImageTwoView
        
        if (svc!.senderInt == 1){
            self.imageOne = svc!.tempImageView.image
        }
        else if (svc!.senderInt == 2){
            self.imageTwo = svc!.tempImageView.image
        }
        
    }
    
    @IBAction func onImageOne(sender: AnyObject) {
        
        print("hello Mutha")
        performSegueWithIdentifier("SegueOne", sender: imageOneButton)
        
    }
    
    
    @IBAction func onImageTwo(sender: AnyObject) {

        print("hello MuthaTwoo")
        
        performSegueWithIdentifier("SegueTwo", sender: imageTwoButton)
    
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        var newImage = segue.destinationViewController as! ImageTwoView
        
        
        print(sender!.tag)
        
        newImage.senderInt = sender!.tag
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
