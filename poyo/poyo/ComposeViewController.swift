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
import MBProgressHUD

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

    @IBOutlet weak var postButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
        poyoField.delegate = self
        optionOneLabel.delegate = self
        optionTwoLabel.delegate = self
        setPrivate = false
        self.locationManager.requestAlwaysAuthorization()
        poyoField.layer.borderColor = UIColor.grayColor().CGColor
        optionOneLabel.layer.borderColor = UIColor.grayColor().CGColor
        optionTwoLabel.layer.borderColor = UIColor.grayColor().CGColor
        self.postButton.layer.cornerRadius = self.postButton.frame.size.width / 2;
        self.postButton.clipsToBounds = true

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
        //playButton.setImage(UIImage(named: "play.png"), forState: UIControlState.Normal)
        imageOneView.layer.borderWidth = 1
        imageOneView.layer.borderColor = UIColor.lightGrayColor().CGColor

        imageTwoView.layer.borderWidth = 1
        imageTwoView.layer.borderColor = UIColor.lightGrayColor().CGColor


        self.imageOneButton.tag = 1
        self.imageTwoButton.tag = 2

        optionOneLabel.text = ""
        optionTwoLabel.text = ""

        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        textFieldDidBeginEditing(poyoField)
        textFieldDidBeginEditing(optionOneLabel)
        textFieldDidBeginEditing(optionTwoLabel)
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var centerView: UIView!
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
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        view.endEditing(true)
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
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //let secondsLeftString = secondsLeftInt as! String
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
            MBProgressHUD.hideHUDForView(self.view, animated: true)

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
            MBProgressHUD.hideHUDForView(self.view, animated: true)

            return
        }
        if (optionOneLabel.text == "" && imageOneView.image == nil){
            imageOneView.layer.borderWidth = 1
            imageOneView.layer.borderColor = UIColor.redColor().CGColor
            MBProgressHUD.hideHUDForView(self.view, animated: true)

            return
        }
        if (optionTwoLabel.text == "" && imageTwoView.image == nil){
            imageTwoView.layer.borderWidth = 1
            imageTwoView.layer.borderColor = UIColor.redColor().CGColor
            MBProgressHUD.hideHUDForView(self.view, animated: true)

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
            MBProgressHUD.hideHUDForView(self.view, animated: true)

            return
        }

            if (setPrivate == false){
                UserMedia.postPoyoImage(withCaption: poyotext, withCaption: longitudeLabel, withCaption: latitudeLabel, withCaption: optionOneLabel.text, withCaption: optionTwoLabel.text, withCaption: String(datePick!), imageOne: imageOne, imageTwo: imageTwo, withCompletion: { (success: Bool, error: NSError?) -> Void in
                    print(success)
//<<<<<<< HEAD
                    print("Hell yea")
//=======
                    MBProgressHUD.hideHUDForView(self.view, animated: true)

//>>>>>>> develop
                    self.performSegueWithIdentifier("postSegue", sender: nil)
                })
                print("did something send?")
            }
            else if (setPrivate == true){
                UserMedia.postPrivatePoyo(withCaption: poyotext, withCaption: longitudeLabel, withCaption: latitudeLabel, withCaption: optionOneLabel.text, withCaption: optionTwoLabel.text, withCaption: String(datePick!), imageOne: imageOne, imageTwo: imageTwo, withCaption: privatePassword, withCompletion: { (success: Bool, error: NSError?) -> Void in
                    print(success)
//<<<<<<< HEAD
                    print("Hell ya private poll")
//=======
                    MBProgressHUD.hideHUDForView(self.view, animated: true)

//>>>>>>> develop
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

    func setImage(image: UIImage, int: Int, rev: Int) {
        if (int == 1){
            let sizeOne = CGSize(width: 500.0, height: 500.0)
            let resizeImage = resize(image, newSize: sizeOne)
            imageOne = resizeImage
            if (rev == 1){
                self.imageOneView.transform = CGAffineTransformMakeScale(-1, 1)
            }
        }
        else if (int == 2){
            let sizeTwo = CGSize(width: 500.0, height: 500.0)
            let resizeImageTwo = resize(image, newSize: sizeTwo)
            imageTwo = resizeImageTwo
            if (rev == 1){
                self.imageTwoView.transform = CGAffineTransformMakeScale(-1, 1)
            }

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
