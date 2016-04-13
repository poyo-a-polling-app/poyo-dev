//
//  CommentsViewController.swift
//  poyo
//
//  Created by Takashi Wickes on 3/31/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import Parse
import UIKit
import MapKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {



    @IBOutlet weak var mapView: MKMapView!
    var passedPoyo: PFObject!
    var commentsArray: [NSDictionary]?
    var userAnswer: Int?


    @IBOutlet weak var commentInputField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputFieldView: UIView!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    var animalFarm = ["ant-eater", "badger", "bear", "buffalo", "deer", "elephant", "fennec", "fox", "giraffe", "gorilla", "hedgehog", "hippopotamus", "hog", "jaguar", "koala", "lion", "monkey", "moose", "panda", "rabbit", " racoon", "rhinoceros", "sloth", "snake", "squirrel", "tiger", "turtle", "wild-horse", "wolf", "zebra"]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
        let poyoLat = Double(passedPoyo["latitude"] as! String)
        let poyoLong = Double(passedPoyo["longitude"] as! String)
        print("........poyoLat: \(poyoLat!) poyoLong: \(poyoLong!) hey bitch this working")
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(poyoLat!, poyoLong!), MKCoordinateSpanMake(0.1, 0.1))


        mapView.setRegion(sfRegion, animated: false)

        let poyoLocation = CLLocationCoordinate2DMake(poyoLat!, poyoLong!)
        //let pin = MKPinAnnotationView()
        //pin.pinColor = .Green

        let dropPin = MKPointAnnotation()
        dropPin.coordinate = poyoLocation
        dropPin.title = "Poyo"
        mapView.addAnnotation(dropPin)


        let poyo1Answers = passedPoyo["option1Answers"] as! [NSDictionary]
        let poyo2Answers = passedPoyo["option2Answers"] as! [NSDictionary]
        /*var poyo1Lats = [] as! [Double]
        var poyo2Lats = [] as! [Double]
        var poyo1Longs = [] as! [Double]
        var poyo2Longs = [] as! [Double]
        */
        for answer in poyo1Answers {
            let poyo1Lat = answer["latitude"] as! Double
            let poyo1Long = answer["longitude"] as! Double
            //poyo1Lats.append(poyo1Lat)
            //poyo1Longs.append(poyo1Long)

            let answerLocation = CLLocationCoordinate2DMake(poyo1Lat, poyo1Long)
            //let pin = MKPinAnnotationView()
            //pin.pinColor = .Green

            let pin = MKPointAnnotation()
            pin.coordinate = answerLocation
            pin.title = "Blue"
            mapView.addAnnotation(pin)

        }


        for answer in poyo2Answers {
            let poyo2Lat = answer["latitude"] as! Double
            let poyo2Long = answer["longitude"] as! Double
            //poyo2Lats.append(poyo2Lat)
            //poyo2Longs.append(poyo2Long)

            let answerLocation = CLLocationCoordinate2DMake(poyo2Lat, poyo2Long)
            //let pin = MKPinAnnotationView()
            //pin.pinColor = .Green

            let pin = MKPointAnnotation()
            pin.coordinate = answerLocation
            pin.title = "Red"
            mapView.addAnnotation(pin)

        }

//        commentInputField.delegate = self

        self.tabBarController?.tabBar.hidden = true

        commentsArray = passedPoyo["comments"] as? [NSDictionary]

        print(passedPoyo)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }

    func randomChar() {
        //check if they have already answered
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


        if annotation.title! == "Blue" {
            annotationView!.image = UIImage(named: "Icon-167")

        } else {
            annotationView!.image = UIImage(named: "Icon")
        }

        return annotationView
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let commentsArray = commentsArray {
            print(commentsArray.count)
            return commentsArray.count
        } else {
            return 0
        }

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentViewCell

        print("User = \(commentsArray![indexPath.row]["user"]?.objectId)")
        print("Current User --asd-- \(PFUser.currentUser()?.objectId)")
        if commentsArray![indexPath.row]["user"]?.objectId == PFUser.currentUser()?.objectId {
            print("ANSWER FROM CURRENT USER")
            switch userAnswer! {
            case 1:
                cell.backgroundColor = UIColor.greenColor()
            case 2:
                cell.backgroundColor = UIColor.blueColor()
            default:
                cell.backgroundColor = UIColor.whiteColor()
            }
        } else {
            print("ANSWER FROM NOTN NOTNONOTNOTNOT CURRENT USER")

            let colorSet = findColor(commentsArray![indexPath.row]["user"] as! PFUser)
            switch colorSet {
            case 1:
                cell.backgroundColor = UIColor.greenColor()
            case 2:
                cell.backgroundColor = UIColor.blueColor()
            default:
                cell.backgroundColor = UIColor.whiteColor()
            }
        }




        let commentDate = commentsArray![indexPath.row]["timeStamp"]! as! NSDate
        print(commentDate)
        cell.commentTextLabel.text = commentsArray![indexPath.row]["commentString"] as? String
        cell.dateLabel.text = timeElapsed(commentDate)

        var animalString = commentsArray![indexPath.row]["anonCharacter"] as! String
        cell.anonCharacterImage.image = UIImage(named: animalString)

        return cell

    }

    func findColor(user: PFUser) -> Int {

        //search option1Array
        let options1Array = passedPoyo["option1Answers"] as! [String]

        if options1Array.contains({$0 == user.objectId}){
            print("Answered 1")
            return 1
        }

        //search option2Array
        let options2Array = passedPoyo["option2Answers"] as! [String]

        if options2Array.contains({$0 == user.objectId}){
            print("Answered 2")
            return 2
        }
        print("None answered")
        return 0
    }

    func assignCharacter(commentsArray: [NSDictionary]) -> String {
        if commentsArray.contains({$0["user"]!.objectId == PFUser.currentUser()?.objectId}){
            print("User has already been assigned")
            return commentsArray[0]["anonCharacter"] as! String
        }

        while true{
            var randomInt = Int(arc4random_uniform(28))
            print("RandomInt: \(randomInt)")
            if commentsArray.contains({$0["anonCharacter"] as! String == animalFarm[randomInt]}) {
                print("Animal already used")
                continue
            } else {
                return animalFarm[randomInt]
            }
        }


    }

    @IBAction func sendCommentPressed(sender: AnyObject) {

        let newCommentString = commentInputField.text!




        if newCommentString != "" {



            let query : PFQuery = PFQuery(className: "PoyosImageTest")

            query.whereKey("objectId", equalTo: passedPoyo.objectId!)

            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in




                for object in objects! {

                    var tempArray: [NSDictionary]
                    if object["comments"] != nil {
                        tempArray = object["comments"] as! [NSDictionary]
                    } else {
                        tempArray = []
                    }

                    var animalString = self.assignCharacter(tempArray)


                    let newComment:NSDictionary = ["commentString": newCommentString, "user": PFUser.currentUser()! , "timeStamp": NSDate(), "anonCharacter": animalString]
                    print("Comment attempted to post: \(newComment)")




                    tempArray.append(newComment)
                    object["comments"] = tempArray

                    object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        if let error = error {
                            print("ERROR: Comment was not added to Parse")
                            print(error.localizedDescription)

                        } else {
                            print("Comment was added successfully")
                            self.passedPoyo = object
                            self.commentsArray = self.passedPoyo["comments"] as? [NSDictionary]

                            print(self.passedPoyo)

                            self.tableView.reloadData()
                        }
                    }

                }

            }

        }

        commentInputField.text = ""
    }


    func keyboardWillShow(notification: NSNotification) {

        adjustingHeight(true, notification: notification)
    }

    func keyboardWillHide(notification: NSNotification) {

        adjustingHeight(false, notification: notification)
    }

    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        // 4
        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        //5

        UIView.setAnimationsEnabled(true)

        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: {
            self.bottomConstraint.constant += changeInHeight

            }, completion: { finished in
                print("Done!")
        })

//        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: { () -> Void in
////            self.inputFieldView.frame.origin.y += changeInHeight
//            self.bottomConstraint.constant += changeInHeight
//        })

    }

    func timeElapsed(date: NSDate) -> String {

        let timeElapsed = Int(0 - date.timeIntervalSinceNow)

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
//
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        txtField.resignFirstResponder()
//        return true;
//    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

class poyoComment{
    var commentString: String?
    var user: PFUser?
    var timeStamp: NSDate?
    var anonCharacter: UIImage

    init(newCommentString: String) {
        commentString = newCommentString
        user = PFUser.currentUser()
        timeStamp = NSDate()
        anonCharacter = UIImage(named: "anteater")!
    }
}
