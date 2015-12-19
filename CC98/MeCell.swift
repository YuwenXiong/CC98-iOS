//
//  MeCell.swift
//  CC98
//
//  Created by CCNT on 12/19/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import UIKit

class MeCell:UITableViewCell{
    
    
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}