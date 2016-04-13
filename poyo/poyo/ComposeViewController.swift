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

//protocol ComposeViewDelegate {
//
//}

class ComposeViewController: UIViewController, CLLocationManagerDelegate, ImageTwoViewDelegate, UITextFieldDelegate, SettingsViewDelegate{

    var passedDater: NSDate?

    var imageTwo: UIImage?
    var imageOne: UIImage?

    var resizeImage: UIImage?
    var resizeImageTwo: UIImage?

    var imageObject: PFObject?

    var setPrivate: Bool?
    var privatePassword: String? = ""

    var setDateBool: Bool?
    var datePick: Int? = 75600
    
    var colorPallete: [String: UIColor] = ["orange": UIColor(red:0.99, green:0.73, blue:0.34, alpha:1.0),
        "red": UIColor(red:0.96, green:0.52, blue:0.53, alpha:1.0),
        "pink": UIColor(red:0.97, green:0.67, blue:0.71, alpha:1.0),
        "yellow": UIColor(red:1.0, green:0.91, blue:0.29, alpha:1.0),
        "green": UIColor(red:0.85, green:0.9, blue:0.31, alpha:1.0),
        "teal": UIColor(red:0.45, green:0.79, blue:0.76, alpha:1.0),
        "blue": UIColor(red:0.33, green:0.64, blue:1.0, alpha:1.0)
    ]
    
    var colorPalleteKeys = [String]()

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

    @IBOutlet weak var imageOneButton: UIButton!
    @IBOutlet weak var imageTwoButton: UIButton!
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
        setPrivate = false
        self.locationManager.requestAlwaysAuthorization()
        
        colorPalleteKeys = [String](colorPallete.keys)

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        datePick = 75600

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


        self.imageOneButton.tag = 1
        self.imageTwoButton.tag = 2

        optionOneLabel.text = ""
        optionTwoLabel.text = ""

        self.tabBarController?.tabBar.hidden = false

        textFieldDidBeginEditing(poyoField)
        textFieldDidBeginEditing(optionOneLabel)
        textFieldDidBeginEditing(optionTwoLabel)
        // Do any additional setup after loading the view.
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        textField.layer.borderWidth = 0
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(animated: Bool) {
        imageOneView.image = imageOne
        if (imageOne != nil){
            imageOneView.layer.borderWidth = 0
        }
        imageTwoView.image = imageTwo
        if (imageTwo != nil){
            imageTwoView.layer.borderWidth = 0
        }
        print(String(datePick!))
        self.tabBarController?.tabBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: AnyObject = locations[locations.count - 1]

        latitudeLabel = String(format: "%.4f", latestLocation.coordinate.latitude)
        longitudeLabel = String(format: "%.4f", latestLocation.coordinate.longitude)

        if location == nil {
            location = latestLocation as! CLLocation
        }

    }

    @IBAction func onPost(sender: AnyObject) {
        //let secondsLeftString = secondsLeftInt as! String
        var randomInt = Int(arc4random_uniform(7))
        var colorTwo = colorPalleteKeys[randomInt]
        var colorOne = ""

        while true {
            var randomInt = Int(arc4random_uniform(7))
            if colorTwo != colorPalleteKeys[randomInt] {
                colorOne = colorPalleteKeys[randomInt]
                break
            }
        }
        
        
        var poyotext = String()
        if (poyoField.text == ""){
            poyotext = ("\(optionOneLabel.text!) or \(optionTwoLabel.text!)")
        }
        else {
            poyotext = poyoField.text!
        }

        print(imageOneView.image)

        if (optionOneLabel.text == "" && imageOneView.image == nil && optionTwoLabel.text == "" && imageTwoView.image == nil){
            poyoField.layer.borderWidth = 1
            poyoField.layer.cornerRadius = 8.0
            poyoField.layer.borderColor = UIColor.redColor().CGColor
            optionTwoLabel.layer.borderWidth = 1
            optionTwoLabel.layer.cornerRadius = 8.0
            optionTwoLabel.layer.borderColor = UIColor.redColor().CGColor

            optionOneLabel.layer.borderWidth = 1
            optionOneLabel.layer.cornerRadius = 8.0
            optionOneLabel.layer.borderColor = UIColor.redColor().CGColor

            imageOneView.layer.borderWidth = 1
            imageOneView.layer.borderColor = UIColor.redColor().CGColor

            imageTwoView.layer.borderWidth = 1
            imageTwoView.layer.borderColor = UIColor.redColor().CGColor
            return
        }
        if (optionOneLabel.text == "" && imageOneView.image != nil && optionTwoLabel.text == "" && imageTwoView.image != nil && poyoField.text == ""){
            poyoField.layer.borderWidth = 1
            poyoField.layer.cornerRadius = 8.0
            poyoField.layer.borderColor = UIColor.redColor().CGColor
            optionTwoLabel.layer.borderWidth = 1
            optionTwoLabel.layer.cornerRadius = 8.0
            optionTwoLabel.layer.borderColor = UIColor.redColor().CGColor

            optionOneLabel.layer.borderWidth = 1
            optionOneLabel.layer.cornerRadius = 8.0
            optionOneLabel.layer.borderColor = UIColor.redColor().CGColor
            return
        }
        if (optionOneLabel.text == "" && imageOneView.image == nil){
            imageOneView.layer.borderWidth = 1
            imageOneView.layer.borderColor = UIColor.redColor().CGColor
            return
        }
        if (optionTwoLabel.text == "" && imageTwoView.image == nil){
            imageTwoView.layer.borderWidth = 1
            imageTwoView.layer.borderColor = UIColor.redColor().CGColor
            return
        }
        if (imageOneView.image == nil || imageTwoView.image == nil){
            if imageOneView.image == nil{
                imageOneView.layer.borderWidth = 1
                imageOneView.layer.borderColor = UIColor.redColor().CGColor
            }
            else if imageTwoView.image == nil {
                imageTwoView.layer.borderWidth = 1
                imageTwoView.layer.borderColor = UIColor.redColor().CGColor
            }
            return
        }

            if (setPrivate == false){
                UserMedia.postPoyoImage(withCaption: poyotext, withCaption: longitudeLabel, withCaption: latitudeLabel, withCaption: optionOneLabel.text, withCaption: optionTwoLabel.text, withCaption: String(datePick!), imageOne: imageOne, imageTwo: imageTwo, withCaption: colorOne, withCaption: colorTwo, withCompletion: { (success: Bool, error: NSError?) -> Void in
                    print(success)
                    self.performSegueWithIdentifier("postSegue", sender: nil)
                })
                print("did something send?")
            }
            else if (setPrivate == true){
                UserMedia.postPrivatePoyo(withCaption: poyotext, withCaption: longitudeLabel, withCaption: latitudeLabel, withCaption: optionOneLabel.text, withCaption: optionTwoLabel.text, withCaption: String(datePick!), imageOne: imageOne, imageTwo: imageTwo, withCaption: privatePassword,  withCaption: colorOne, withCaption: colorTwo, withCompletion: { (success: Bool, error: NSError?) -> Void in
                    print(success)
                    self.performSegueWithIdentifier("postSegue", sender: nil)
                })
                print("did something private send?")
            }

        poyoField.text = ""
        optionOneLabel.text = ""
        optionOneLabel.text = ""
        imageOne = nil
        imageTwo = nil
        setPrivate = false
        privatePassword = ""
        datePick = 75600
    }

    func characterCounter() {
        let characterCount = poyoField.text!.characters.count
        let characterOneCount = optionOneLabel.text!.characters.count
        let characterTwoCount = optionTwoLabel.text!.characters.count

        let charactersLeft = 80 - characterCount
        let charactersOneLeft = 40 - characterOneCount
        let charactersTwoLeft = 40 - characterTwoCount

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

    func nilToNull(value : AnyObject?) -> AnyObject? {
        if value == nil {
            return NSNull()
        } else {
            return value
        }
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

    func setImage(image: UIImage, int: Int) {
        if (int == 1){
            let sizeOne = CGSize(width: 500.0, height: 500.0)
            let resizeImage = resize(image, newSize: sizeOne)
            imageOne = resizeImage
        }
        else if (int == 2){
            let sizeTwo = CGSize(width: 500.0, height: 500.0)
            let resizeImageTwo = resize(image, newSize: sizeTwo)
            imageTwo = resizeImageTwo
        }
    }

    func didPrivate(flag: Bool, password: String!) {
        if (flag == true){
            privatePassword = password
            setPrivate = true
        }
        else {
            privatePassword = nil;
            setPrivate = false
        }
    }

    func didDate(flag: Bool, date: Int!, dater: NSDate){
        if (flag == true){
            datePick = date
            setDateBool = true
            passedDater = dater

        }
        else {
            setDateBool = false
            datePick = 75600
        }
    }

    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image

        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.identifier == "onImageOne"){
                let newImage : ImageTwoView = segue.destinationViewController as! ImageTwoView
                newImage.delegate = self
            newImage.senderInt = sender!.tag
        }
        else if (segue.identifier == "onImageTwo"){
                let newImage : ImageTwoView = segue.destinationViewController as! ImageTwoView
                newImage.delegate = self
            newImage.senderInt = sender!.tag
        }
        else if (segue.identifier == "backSegue"){
            let settings : SettingsViewController = segue.destinationViewController as! SettingsViewController
            print("OH NOOOO")
            settings.delegate = self
            settings.passedPassword = privatePassword
            settings.passedPrivate = setPrivate
            settings.passedDate = setDateBool
            if (setDateBool == true){
                settings.passerDate = passedDater
            }
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
