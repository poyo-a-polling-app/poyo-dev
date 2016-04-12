//
//  CommentViewCell.swift
//  poyo
//
//  Created by Takashi Wickes on 4/1/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {

    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var anonCharacterImage: UIImageView!
    
    @IBOutlet weak var iconBackView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentTextLabel.preferredMaxLayoutWidth = commentTextLabel.frame.size.width

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
