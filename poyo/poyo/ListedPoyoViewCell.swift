//
//  ListedPoyoViewCell.swift
//  poyo
//
//  Created by Takashi Wickes on 3/5/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import Parse

class ListedPoyoViewCell: UITableViewCell {
    //weak var viewController:listedPoyosViewController
    
    @IBOutlet weak var collapsedView: UIView!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var votesLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var option1Button: subclassedUIButton!
    
    @IBOutlet weak var option2Button: subclassedUIButton!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    var poyo: PFObject?
    
    class var expandedHeight: CGFloat { get { return 300 } }
//    class var defaultHeight: CGFloat { get { return 100 } }
    class var defaultHeight: CGFloat { get { return 100 } }

    var alreadyAnswered: Int = 0
    
    
    
    var frameAdded = false
    //    var expandedHeight: CGFloat = 200
    //    var defaultHeight: CGFloat = 44
    
    func checkHeight(){
        collapsedView.hidden = (frame.size.height < ListedPoyoViewCell.expandedHeight)
    }
    /*@IBAction func killCell(sender: AnyObject) {
        UserMedia.killPoyo(self.poyo)
        self.hidden = true
        self.
    }*/
    
    func killCell(){
        UserMedia.killPoyo(self.poyo)
    }
    
    func watchFrameChanges(){
        addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        if(!frameAdded){
            checkHeight()
            frameAdded = true
        }
    }
    
    func ignoreFrameChanges(){
        if(frameAdded){
            removeObserver(self, forKeyPath: "frame")
            frameAdded = false
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    

    
}
