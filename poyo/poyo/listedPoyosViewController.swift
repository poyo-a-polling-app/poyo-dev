
//
//  listedPoyosViewController.swift
//  poyo
//
//  Created by Takashi Wickes on 3/4/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import CoreLocation
import Parse


class listedPoyosViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var selectedIndexPath: NSIndexPath?

    var locationManager = CLLocationManager()
    var location: CLLocation!

    var frameAdded = false
    var chosenSaved = false
    var colorPallete: [String: UIColor] = ["orange": UIColor(red:0.99, green:0.73, blue:0.34, alpha:1.0),
       "red": UIColor(red:0.96, green:0.52, blue:0.53, alpha:1.0),
       "pink": UIColor(red:0.97, green:0.67, blue:0.71, alpha:1.0),
       "yellow": UIColor(red:1.0, green:0.91, blue:0.29, alpha:1.0),
       "green": UIColor(red:0.85, green:0.9, blue:0.31, alpha:1.0),
       "teal": UIColor(red:0.45, green:0.79, blue:0.76, alpha:1.0),
       "blue": UIColor(red:0.33, green:0.64, blue:1.0, alpha:1.0)
    ]

    var feed: [PFObject]?

    var radius: CLLocationDistance = 100

    var chosenOption = [poyoChosen]()

    var currentUserAnswer = [Int]()

    var images = [poyoImages]()
    var rowHeights = [CGFloat]()

    var refreshControl: UIRefreshControl?

    var reloadPopular = true

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None


        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)

        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            //print("Location Successful")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            location = nil
        } else {
            //print("No location")
        }
        reloadAllData()
        tableView.reloadData()


    }

    func refresh(sender: AnyObject) {

        chosenSaved = false
        reloadAllData()
        populateChosenOption()
        tableView.reloadData()
        self.refreshControl?.endRefreshing()


    }



    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false

        reloadAllData()
        populateChosenOption()
        tableView.reloadData()
    }

    override func viewDidDisappear(animated: Bool) {
        reloadAllData()
        populateChosenOption()
        tableView.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        reloadAllData()
        populateChosenOption()
        tableView.reloadData()
        //print("ASLKNIASNFLIANSINFILANSLFNIASNIFIASNLFILAIFNLASNLFINAISNFILASFIN")
    }

    func popularity(indexPathRow: Int, date: NSDate) -> Double {

        var votesOneCount = CGFloat(countVotes(indexPathRow, option: 1))
        var votesTwoCount = CGFloat(countVotes(indexPathRow, option: 2))
        var totalCount = Int(votesOneCount + votesTwoCount)

        var order = log10(Double(max(abs(totalCount), 1)))
        var secondsElapsed = Double(date.timeIntervalSinceNow)
        ////print("Score: \(order + secondsElapsed/45000)")

        return order + secondsElapsed/45000

//        s = score(ups, downs)
//        order = log(max(abs(s), 1), 10)
//        sign = 1 if s > 0 else -1 if s < 0 else 0
//        seconds = epoch_seconds(date) - 1134028003
//        return round(sign * order + seconds / 45000, 7)
    }


    func reloadAllData() {


        let query = PFQuery(className:"PoyosImageTest")
        query.orderByDescending("popularity")
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                self.feed = []
                var indexCount = 0
                print(media)
                for (index, medium) in media.enumerate() {
                    if index >= self.chosenOption.count {
                        self.chosenOption.append(poyoChosen(poyoObjectID: "0", chosenNumber: 0, userAlreadyAnswered: 0))
                    }
                    let timeLimit = Int(medium["timeLimit"] as! String)
                    let date = medium["time"] as! NSDate
                    let timeElapsed = Int(0 - date.timeIntervalSinceNow)
                    if(timeElapsed > timeLimit!) {
                        UserMedia.killPoyo(medium)
                        continue
                    } else {
                        self.feed!.append(medium)
                        ////print("Index: \(indexCount)")

                        var popularityRating = self.popularity(indexCount, date: medium["time"] as! NSDate)
                        if medium["popularity"] == nil || self.reloadPopular {
                            medium["popularity"] =
                                medium.saveInBackground()
                        }
                        indexCount++




                    }

                    var tempPoyoImage = poyoImages(index: indexCount - 1)

                    let options1ImageLink = medium.valueForKey("optionImageOne") as! PFFile

                    options1ImageLink.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
                        if (error == nil) {

                            if(self.images[index].imageOptionOne != nil && self.images[index].imageOptionOne!.isEqual(UIImage(data: imageData!))){
                                //checks if image is equal to current image
                            } else {
                                tempPoyoImage.imageOptionOne = UIImage(data:imageData!)
                            }

                        } else {
                            ////print("Connection failed to be made!!")
                        }
                    }

                    let options2ImageLink = medium.valueForKey("optionImageTwo") as! PFFile

                    options2ImageLink.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
                        if (error == nil) {
                            if(self.images[index].imageOptionTwo != nil && self.images[index].imageOptionTwo!.isEqual(UIImage(data: imageData!))){
                                //checks if image is equal to current image
                            } else {
                                tempPoyoImage.imageOptionTwo = UIImage(data:imageData!)
                            }
                        } else {
                            ////print("Connection failed to be made!!")
                        }
                    }

                    ////print("Images count = \(self.images.count)")
                    ////print("IndexPathRow = \(tempPoyoImage.indexPathRow)")

                    if self.images.count == tempPoyoImage.indexPathRow {
                        ////print("Added Image to images")
                        self.images.append(tempPoyoImage)
                    } else {
                        ////print("Replaced the old image")
                        self.images[indexCount - 1] = tempPoyoImage
                        ////print("ASDASFSAFafasf")
                    }


                }
//                if !self.chosenSaved {
                    ////print("Populated the Chosen Option Array")
                    self.populateChosenOption()
//                }
                self.tableView.reloadData()






                ////print("IT ACCESSED THE DATA!!!!!")

            } else {
                ////print("COULD NOT ACCESS THE DATA")

            }
        }

        if chosenOption.count != 0 {
            chosenSaved = true
        }

        reloadPopular = false

        if feed == nil {
            tableView.hidden = true
        }


    }

    func populateChosenOption() {
        var tempArray = [poyoChosen]()
        if feed != nil {
            for item in feed! {
                ////print("======Populating Checked Option Array======")
                let poyo = item

                var userID = PFUser.currentUser()

                //populate for Option 1
                var options1 = poyo["option1Answers"] as! [NSDictionary]
                var options1Array = options1.map { $0["userId"] as! String}

                if options1Array.contains({$0 == userID!.objectId}){
                    ////print("Already answered 1")
                    let newPoyoChosen = poyoChosen(poyoObjectID: userID!.objectId!, chosenNumber: 1, userAlreadyAnswered: 1)
                    tempArray.append(newPoyoChosen)
                    continue
                }

                //populate for option 2
                var options2 = poyo["option2Answers"] as! [NSDictionary]
                var options2Array = options2.map { $0["userId"] as! String}

                if options2Array.contains({$0 == userID!.objectId}){
                    ////print("Already answered 2")
                    let newPoyoChosen = poyoChosen(poyoObjectID: userID!.objectId!, chosenNumber: 2, userAlreadyAnswered: 2)
                    tempArray.append(newPoyoChosen)
                    continue
                }

                //if no answer option
                ////print("None answered")
                tempArray.append(poyoChosen(poyoObjectID: "0", chosenNumber: 0, userAlreadyAnswered: 0))
            }
            chosenOption = tempArray
            ////print("Chosen Option: \(chosenOption)")
//            tableView.reloadData()
        } else {
            ////print("Chosen did not occur!")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feed = feed {
            rowHeights = [CGFloat](count: feed.count, repeatedValue: 340.0)
            return feed.count

        } else {
            return 0
        }
    }



    func countVotes(indexPathrow: Int, option: Int) -> Int {

        if indexPathrow < self.feed?.count {
            let poyo = self.feed![indexPathrow]
            var chosen1vote = 0
            var chosen2vote = 0
            var alreadyAnswered = 0


            print("alreadyAnswered \(alreadyAnswered)")

            if chosenOption[indexPathrow].recentVote == chosenOption[indexPathrow].userAlready {
                print("No need to change vote count")
                switch option {
                    case 1:
                    return poyo["option1Answers"].count
                    case 2:
                    return poyo["option2Answers"].count
                    default:
                    return 999999
                }
            }


            if chosenOption[indexPathrow].recentVote == 1 {
                chosen1vote = 1
                if chosenOption[indexPathrow].userAlready != 0 {
                    chosen2vote = -1
                }
            } else if chosenOption[indexPathrow].recentVote == 2 {
                chosen2vote = 1
                if chosenOption[indexPathrow].userAlready != 0 {
                    chosen1vote = -1
                }
            }

            switch option {
            case 1:

                return poyo["option1Answers"].count + chosen1vote - alreadyAnswered

            case 2:

                return poyo["option2Answers"].count + chosen2vote - alreadyAnswered
            default:
                return 0
            }

        }

        return 0
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("ListedPoyoViewCell", forIndexPath: indexPath) as! ListedPoyoViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        let poyo = self.feed![indexPath.row]

        cell.poyo = poyo
        let date = poyo["time"] as! NSDate
        let question = poyo["caption"] as! String
        let option1 = poyo["optionOne"] as! String
        let option2 = poyo["optionTwo"] as! String
        let poyoLatitude = poyo["latitude"].doubleValue as! CLLocationDegrees
        let poyoLongitude = poyo["longitude"].doubleValue as! CLLocationDegrees

        var poyoLocation = CLLocation(latitude: poyoLatitude, longitude: poyoLongitude)
        var distanceFromPoyo: CLLocationDistance = location.distanceFromLocation(poyoLocation)


        if images[indexPath.row].imageOptionOne != UIImage(named: "Icon-167") {
            cell.option1Button.setBackgroundImage(images[indexPath.row].imageOptionOne, forState: UIControlState.Normal)
        }
        if images[indexPath.row].imageOptionTwo != UIImage(named: "Icon-167") {
            cell.option2Button.setBackgroundImage(images[indexPath.row].imageOptionTwo, forState: UIControlState.Normal)
        }


        //COMMENTS
        cell.commentPreviewColorOne.hidden = true
        cell.commentPreviewOne.hidden = true
        cell.commentPreviewColorTwo.hidden = true
        cell.commentPreviewTwo.hidden = true
        cell.commentPreviewColorThree.hidden = true
        cell.commentPreviewThree.hidden = true

//        if cell.checkHeight() {
//            cell.seeComments.hidden = true
//        }
//


        var rowHeightForCell:CGFloat = 340
        let poyoComments = poyo["comments"] as? [NSDictionary]
        print("Row: \(indexPath.row)  =====  \(poyoComments)")




        if poyoComments != nil {
            cell.seeComments.setTitle("View all \(poyoComments!.count) comments", forState: UIControlState.Normal)

            for (index, comments) in poyoComments!.enumerate() {
                if index >= 3 {
                    break
                }

                cell.commentPreviewColorOne.layer.cornerRadius = cell.commentPreviewColorOne.frame.width / 2
                cell.commentPreviewColorTwo.layer.cornerRadius = cell.commentPreviewColorTwo.frame.width / 2
                cell.commentPreviewColorThree.layer.cornerRadius = cell.commentPreviewColorThree.frame.width / 2


                var commentColor = UIColor.lightGrayColor()
                let colorSet = findColor(poyoComments![index]["user"] as! PFUser, indexPath: indexPath)
                switch colorSet {
                case 1:
                    commentColor = colorPallete[poyo["option1Color"] as! String]!
                case 2:
                    commentColor = colorPallete[poyo["option2Color"] as! String]!
                default:
                    commentColor = UIColor.lightGrayColor()
                }

                switch index {
                case 0:
                    cell.commentPreviewColorOne.hidden = false
                    cell.commentPreviewOne.hidden = false
                    cell.commentPreviewColorOne.backgroundColor = commentColor
                     cell.commentPreviewOne.text = poyoComments![index]["commentString"] as? String
                    rowHeightForCell += cell.commentPreviewOne.frame.height - 5

                case 1:
                    cell.commentPreviewColorTwo.hidden = false
                    cell.commentPreviewTwo.hidden = false
                    cell.commentPreviewColorTwo.backgroundColor = commentColor
                    cell.commentPreviewTwo.text = poyoComments![index]["commentString"] as? String
                    rowHeightForCell += cell.commentPreviewTwo.frame.height + 19

                case 2:
                    cell.commentPreviewColorThree.hidden = false
                    cell.commentPreviewThree.hidden = false
                    cell.commentPreviewColorThree.backgroundColor = commentColor
                    cell.commentPreviewThree.text = poyoComments![index]["commentString"] as? String
                    rowHeightForCell += cell.commentPreviewThree.frame.height + 9

                default:
                    print("INDEX ERROR")
                }
            }

        } else {
//            cell.seeComments.setTitle("No Comments. Click here to change that!", forState: UIControlState.Normal)

        }

        rowHeights[indexPath.row] = rowHeightForCell

        //checks radius
        if radius < distanceFromPoyo {
            //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)

            //            tableV
        }
        cell.alreadyAnswered = chosenOption[indexPath.row].chosen!

        var votesOneCount = CGFloat(countVotes(indexPath.row, option: 1))
        var votesTwoCount = CGFloat(countVotes(indexPath.row, option: 2))


    // MARK: EDITING LIVE RESULTS
    //calculating total votes

        cell.voteOverlayOne.userInteractionEnabled = false;
        cell.voteOverlayTwo.userInteractionEnabled = false;

        var totalCount = Int(votesOneCount + votesTwoCount)

        if totalCount == 1 {
            cell.votesLabel.text = String(format: "\(totalCount) vote")
        } else {
            cell.votesLabel.text = String(format: "\(totalCount) votes")
        }

        cell.sliderCircle.layer.cornerRadius = cell.sliderCircle.frame.width / 2


        var votesOnePercent = CGFloat(0)
        var votesTwoPercent = CGFloat(0)
    //calculating percentage of votes
        if votesOneCount == 0 && votesTwoCount == 0 {

        } else {
            votesOnePercent = CGFloat(votesOneCount/(votesOneCount + votesTwoCount))
            votesTwoPercent = CGFloat(votesTwoCount/(votesOneCount + votesTwoCount))
        }

        var voteOneHeight = 25 * votesOnePercent
        var voteTwoHeight = 25 * votesTwoPercent

        //////print("votesOnePercent: \(votesOnePercent)")
        //////print("votesTwoPercent: \(votesTwoPercent)")

        cell.votesOne.text = String(format: "\(Int(votesOnePercent*100))")
        cell.votesTwo.text = String(format: "\(Int(votesTwoPercent*100))")

        cell.voteOverlayOne.layer.anchorPoint = CGPointMake(1, 0.5)
        cell.voteOverlayTwo.layer.anchorPoint = CGPointMake(0, 0.5)
        cell.optionOnePreview.layer.anchorPoint = CGPointMake(0, 0.5)
        
        cell.voteOverlayOne.backgroundColor = colorPallete[poyo["option1Color"] as! String]
        cell.voteOverlayTwo.backgroundColor = colorPallete[poyo["option2Color"] as! String]

        let screenSize: CGRect = UIScreen.mainScreen().bounds

        print("PERCENT \(votesOnePercent)")



        UIView.animateWithDuration(0.6, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {

            cell.sliderCircle.frame.origin.x = screenSize.width * votesOnePercent - (cell.sliderCircle.frame.width / 2)
            cell.voteOverlayOne.transform = CGAffineTransformMakeScale(votesOnePercent + 0.001, 1)
            cell.voteOverlayTwo.transform = CGAffineTransformMakeScale(votesTwoPercent + 0.001, 1)
            cell.optionOnePreview.transform = CGAffineTransformMakeScale(votesOnePercent + 0.001, 1)
        }) { (finished: Bool) in
                //print("Animatioed")
        }


        // MARK: CELL EDITING

        cell.questionLabel.text = question
//        cell.option1Button.setTitle(option1, forState: UIControlState.Normal)
//        cell.option2Button.setTitle(option2, forState: UIControlState.Normal)

        cell.option1Button.tag = indexPath.row
        cell.option2Button.tag = indexPath.row

        cell.option1Button.option = 1
        cell.option2Button.option = 2

        cell.option1Button.indexPath = indexPath
        cell.option2Button.indexPath = indexPath

        cell.option1Button.chosenItem = cell.alreadyAnswered
        cell.option2Button.chosenItem = cell.alreadyAnswered

        cell.option1Button.addTarget(self, action: "option1Pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.option2Button.addTarget(self, action: "option1Pressed:", forControlEvents: UIControlEvents.TouchUpInside)

        cell.timeLabel.text = timeElapsed(date)
        cell.seeComments.tag = indexPath.row
        cell.seeAllComments.tag = indexPath.row

        print("ALKNSLNACSCNAKSNLCNA KSC LASNC \(cell.alreadyAnswered)")
        if chosenOption[indexPath.row].chosen! == 0 && chosenOption[indexPath.row].recentVote == 0{
            cell.optionOnePreview.backgroundColor = UIColor.lightGrayColor()
            cell.optionTwoPreview.backgroundColor = UIColor.lightGrayColor()
            rowHeights[indexPath.row] = 310
            cell.voteOverlayOne.hidden = true
            cell.voteOverlayTwo.hidden = true
            cell.votesOne.hidden = true
            cell.votesTwo.hidden = true
            cell.seeComments.hidden = true


        } else {
            cell.voteOverlayOne.hidden = false
            cell.voteOverlayTwo.hidden = false
            cell.votesOne.hidden = false
            cell.votesTwo.hidden = false
            cell.seeComments.hidden = cell.checkHeight()
            cell.optionOnePreview.backgroundColor = colorPallete[poyo["option1Color"] as! String]
            cell.optionTwoPreview.backgroundColor = colorPallete[poyo["option2Color"] as! String]
            switch chosenOption[indexPath.row].chosen! {
            case 1:
                cell.sliderCircle.backgroundColor = colorPallete[poyo["option1Color"] as! String]
            case 2:
                cell.sliderCircle.backgroundColor = colorPallete[poyo["option2Color"]as! String]
            default:
                print("No picture")
            }


        }


        return cell
    }



    func deleteAnswers (indexPath: NSIndexPath) {
        //print("DELETE ANSWERS STARTED")
        let poyo = self.feed![indexPath.row]


        let query : PFQuery = PFQuery(className: "PoyosImageTest")

        query.whereKey("objectId", equalTo: poyo.objectId!)


        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
                //print("Remove options")

                //Deleting from Option 1

                var clean = object["option1Answers"] as! [NSDictionary]
                var cleanArray = clean.map { $0["userId"] as! String}

                cleanArray = cleanArray.filter() {$0 != PFUser.currentUser()?.objectId}

                object["option1Answers"] = cleanArray

                //Deleting from Option 2
                var clean2 = object["option2Answers"] as! [NSDictionary]
                var clean2Array = clean2.map { $0["userId"] as! String}

                clean2Array = clean2Array.filter() {$0 != PFUser.currentUser()?.objectId}

                object["option2Answers"] = clean2Array

                //Saving the Parse into the background
                object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if let error = error {
                        //print("Votes was not deleted Failed")
                        //print(error.localizedDescription)

                    } else {
                        //print("Vote was deleted successfully")
                        self.navigationController?.popViewControllerAnimated(true)
                        self.reloadAllData()
//                        self.tableView.reloadData()
                    }
                }
            }

            //print("HERE ARE THE OBJECTS: \(objects)")
        }
    }

    func addChosenToParse(indexPathRow: Int) {

        //print("########ADDING THE OPTIONS TO PARSE##########")

        let poyo = self.feed![indexPathRow]

        let query : PFQuery = PFQuery(className: "PoyosImageTest")

//        chosenOption[indexPath.row].recentVote = 0;


        query.whereKey("objectId", equalTo: poyo.objectId!)

        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
                //print("ADDING THE NEW VOTES:")

                //print("Remove options")


                let userWithLocation:NSDictionary = ["userId": (PFUser.currentUser()?.objectId)!, "latitude": self.location.coordinate.latitude , "longitude": self.location.coordinate.longitude]

                //Deleting from Option 1
                var clean = object["option1Answers"] as! [NSDictionary]
//                var cleanArray = clean.map { $0["userId"] as! String}

//                cleanArray = cleanArray.filter() {$0["userId"] != PFUser.currentUser()?.objectId}
                clean = clean.filter() {$0["userId"] as! String != PFUser.currentUser()?.objectId}


                object["option1Answers"] = clean

                //Deleting from Option 2
                var clean2 = object["option2Answers"] as! [NSDictionary]
//                var clean2Array = clean.map { $0["userId"] as! String}

//                clean2Array = clean2Array.filter() {$0 != PFUser.currentUser()?.objectId}
                clean2 = clean2.filter() {$0["userId"] as! String != PFUser.currentUser()?.objectId}


                object["option2Answers"] = clean2

                switch self.chosenOption[indexPathRow].chosen! {
                    case 1:

                        var newArray = object["option1Answers"] as! [NSDictionary]
                        //print("Option 1 Done")
                        newArray.append(userWithLocation)
                        object["option1Answers"] = newArray

                    case 2:

                        var newArray = object["option2Answers"] as! [NSDictionary]
                        //print("Option 2 Done")
                        newArray.append(userWithLocation)
                        object["option2Answers"] = newArray

                    default:
                        print("None chosen")
                }

                object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if let error = error {
                        print("Votes was not counted Failed")
                        print(error.localizedDescription)

                    } else {
                        print("Vote was added successfully")
                        self.reloadAllData()
//                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    func option1Pressed(sender: subclassedUIButton!) {

        var cell = tableView.cellForRowAtIndexPath(sender.indexPath!) as! ListedPoyoViewCell

        var pickedButtonId = 0

        let poyo = self.feed![sender.tag]

        pickedButtonId = sender.option!

        switch pickedButtonId {
        case 1:
            //print("Option 1 Done")
            self.chosenOption[sender.tag].chosen = 1
            self.chosenOption[sender.tag].recentVote = 1

        case 2:
            //print("Option 2 Done")
            self.chosenOption[sender.tag].chosen = 2
            self.chosenOption[sender.tag].recentVote = 2

        default:
            print("None chosen")

        }

        tableView.reloadData()
        cell.alreadyAnswered = pickedButtonId
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }

        var indexPaths : Array<NSIndexPath> = []

        if let previous = previousIndexPath {
            indexPaths += [previous]
            addChosenToParse(indexPath.row)

        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }

        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }

    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! ListedPoyoViewCell).watchFrameChanges()
    }

    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! ListedPoyoViewCell).ignoreFrameChanges()


    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            if rowHeights.count <= indexPath.row {
                return ListedPoyoViewCell.expandedHeight
            }
            return rowHeights[indexPath.row]
        } else {
            return ListedPoyoViewCell.defaultHeight
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

    @IBAction func resetLocation(sender: AnyObject) {
        location = nil
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

//    func findColor(user: PFUser, indexPath: NSIndexPath) -> Int {
//
//        //search option1Array
//        print(" Finding colors for \(feed![indexPath.row])")
//
//        let options1Array = feed![indexPath.row]["option1Answers"] as! [String]
//
//        if options1Array.contains({$0 == user.objectId}){
//            print("Answered 1")
//            return 1
//        }
//
//        //search option2Array
//        let options2Array = feed![indexPath.row]["option2Answers"] as! [String]
//
//        if options2Array.contains({$0 == user.objectId}){
//            print("Answered 2")
//            return 2
//        }
//        print("None answered")
//        return 0
//    }
//
    func findColor(user: PFUser, indexPath: NSIndexPath) -> Int {

        //search option1Array
        //        let options1Array = passedPoyo["option1Answers"] as! [NSDictionary]
        print("POPOPOPOPOPOPOPOPOPOPOPO")

        var options1 = feed![indexPath.row]["option1Answers"] as! [NSDictionary]
        var options1Array = options1.map { $0["userId"] as! String}

        if options1Array.contains({$0 == user.objectId}){
            print("Answered 1")
            return 1
        }




        var options2 = feed![indexPath.row]["option2Answers"] as! [NSDictionary]
        var options2Array = options2.map { $0["userId"] as! String}

        if options2Array.contains({$0 == user.objectId}){
            print("Answered 2")
            return 2
        }


        //        if options1Array.contains({$0 == user.objectId}){
        //            print("Answered 1")
        //            return 1
        //        }

        //search option2Array
        //        let options2Array = passedPoyo["option2Answers"] as! [NSDictionary]
        //
        //        if options2Array.contains({$0 == user.objectId}){
        //            print("Answered 2")
        //            return 2
        //        }
        print("None answered")
        return 0
    }


//    @IBAction func seeCommentsPressed(sender: AnyObject) {
//        self.performSegueWithIdentifier("commentsSection", sender: sender)
//    }

//     MARK: - Navigation
//     In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        reloadAllData()

        addChosenToParse(sender!.tag)
        var vc = segue.destinationViewController as! CommentsViewController
        let passPoyo = feed![sender!.tag]

        vc.passedPoyo = passPoyo
        vc.userAnswer = chosenOption[sender!.tag].chosen!



    }


}

class subclassedUIButton: UIButton {
    var indexPath: NSIndexPath?
    var chosenItem: Int?
    var option: Int?
    var urlString: String?
}

class poyoChosen {
    var poyoID: String?
    var chosen: Int?
    var recentVote: Int?
    var userAlready: Int?

    init(poyoObjectID: String, chosenNumber: Int, userAlreadyAnswered: Int) {
        poyoID = poyoObjectID
        chosen = chosenNumber
        recentVote = 0
        userAlready = userAlreadyAnswered
    }
}

class poyoImages {
    var indexPathRow: Int?
    var imageOptionOne: UIImage?
    var imageOptionTwo: UIImage?

    init(index: Int){
        indexPathRow = index
        imageOptionOne = UIImage(named: "Icon-167")
        imageOptionTwo = UIImage(named: "Icon-167")
    }
}

//class poyoComment{
//    var commentString: String?
//    var user: PFUser?
//    var timeStamp: NSDate?
//    var anonCharacter: UIImage
//
//    init(newCommentString: String) {
//        commentString = newCommentString
//        user = PFUser.currentUser()
//        timeStamp = NSDate()
//        anonCharacter = UIImage(named: "anteater")!
//    }
//}
