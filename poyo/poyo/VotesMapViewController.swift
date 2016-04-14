//
//  VotesMapViewController.swift
//  poyo
//
//  Created by Shakeeb Majid on 4/14/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import MapKit
import Parse

class VotesMapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var passedPoyo: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        let poyoLat = Double(passedPoyo!["latitude"] as! String)
        let poyoLong = Double(passedPoyo!["longitude"] as! String)
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
        
        
        let poyo1Answers = passedPoyo!["option1Answers"] as! [NSDictionary]
        let poyo2Answers = passedPoyo!["option2Answers"] as! [NSDictionary]
        
        for answer in poyo1Answers {
            let poyo1Lat = answer["latitude"] as! Double
            let poyo1Long = answer["longitude"] as! Double
            
            let answerLocation = CLLocationCoordinate2DMake(poyo1Lat, poyo1Long)
            
            let pin = MKPointAnnotation()
            pin.coordinate = answerLocation
            pin.title = "Blue"
            mapView.addAnnotation(pin)
            
        }
        
        
        for answer in poyo2Answers {
            let poyo2Lat = answer["latitude"] as! Double
            let poyo2Long = answer["longitude"] as! Double
            
            let answerLocation = CLLocationCoordinate2DMake(poyo2Lat, poyo2Long)
            //let pin = MKPinAnnotationView()
            //pin.pinColor = .Green
            
            let pin = MKPointAnnotation()
            pin.coordinate = answerLocation
            pin.title = "Red"
            mapView.addAnnotation(pin)
            
        }

        
        // Do any additional setup after loading the view.
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
    
    @IBAction func onExit(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {
            
        }
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
