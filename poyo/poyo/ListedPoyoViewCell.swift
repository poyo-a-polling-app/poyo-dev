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
    
    @IBOutlet weak var seeAllComments: UIButton!
    @IBOutlet weak var collapsedView: UIView!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var votesLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var option1Button: subclassedUIButton!
    
    @IBOutlet weak var option2Button: subclassedUIButton!
    
    @IBOutlet weak var commentPreviewColorOne: UIView!
    @IBOutlet weak var commentPreviewOne: UILabel!
    @IBOutlet weak var commentPreviewColorTwo: UIView!
    @IBOutlet weak var commentPreviewTwo: UILabel!
    @IBOutlet weak var commentPreviewColorThree: UIView!
    @IBOutlet weak var commentPreviewThree: UILabel!
//    @IBOutlet weak var distanceLabel: UILabel!
    
    
    @IBOutlet weak var votesOne: UILabel!
    @IBOutlet weak var votesTwo: UILabel!
    
    @IBOutlet weak var voteOverlayOne: UIView!
    @IBOutlet weak var voteOverlayTwo: UIView!
    
    @IBOutlet weak var seeComments: UIButton!
    @IBOutlet weak var optionOnePreview: UIView!
    @IBOutlet weak var optionTwoPreview: UIView!
    
    var poyo: PFObject?
    
    class var expandedHeight: CGFloat { get { return 340 } }
//    class var defaultHeight: CGFloat { get { return 100 } }
    class var defaultHeight: CGFloat { get { return 110 } }

    var alreadyAnswered: Int = 0
    
    
    
    var frameAdded = false
        var expandedHeight: CGFloat = 340
        var defaultHeight: CGFloat = 110
    
    func checkHeight() -> Bool{
        collapsedView.hidden = (frame.size.height < self.expandedHeight)
        return collapsedView.hidden
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
        commentPreviewOne.preferredMaxLayoutWidth = commentPreviewOne.frame.size.width
        commentPreviewTwo.preferredMaxLayoutWidth = commentPreviewTwo.frame.size.width
        commentPreviewThree.preferredMaxLayoutWidth = commentPreviewThree.frame.size.width


    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    

    
}
