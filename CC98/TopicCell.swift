//
//  PostCell.swift
//  CC98
//
//  Created by CCNT on 12/8/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import UIKit

class TopicCell:UITableViewCell{

    
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var boardName: UILabel!

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var title: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        containerView.layer.cornerRadius = 4
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue:0.85, alpha: 0.9).CGColor
        containerView.layer.masksToBounds = true
        //self.backgroundColor = UIColor.greenColor()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        /*
        if selected {
        self.containerView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue:0.85, alpha: 0.4)
        }else{
        self.containerView.backgroundColor = UIColor(red: 0.988, green: 0.988, blue:0.988, alpha: 1)
        }*/
        // Configure the view for the selected state
    }
}