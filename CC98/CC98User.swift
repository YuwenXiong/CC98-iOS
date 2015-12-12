//
//  CC98User.swift
//  CC98
//
//  Created by Orpine on 12/10/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import SwiftyJSON

class CC98User {
    let nickName: String, avatar: String, gender: String
    init(userInfo: JSON) {
        self.nickName = userInfo["name"].stringValue
        let avatar = userInfo["portraitUrl"].stringValue
        self.avatar = avatar.hasPrefix("PresetFace") ? siteURL + avatar : avatar
        self.gender = userInfo["gender"] == 0 ? "male" : "female"
    }
    convenience init(userID: Int) {
        let userInfo = globalDataProcessor.GetUserByID(userID)
        self.init(userInfo: userInfo)
    }
    
}