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
    let nickName: String, avatar: String, gender: String, signature: String
    init(userInfo: JSON) {
        self.nickName = userInfo["name"].stringValue
        let avatar = userInfo["portraitUrl"].stringValue
        self.avatar = avatar.hasPrefix("PresetFace") ? siteURL + avatar : avatar
        self.gender = NSBundle.mainBundle().bundlePath + "/" + (userInfo["isOnline"].boolValue ? "" : "of") + (userInfo["gender"] == 0 ? "Male.gif" : "FeMale.gif")
        self.signature = userInfo["signatureCode"].stringValue
    }
    init() {
        self.nickName = ""
        self.avatar = "face/anonymous.gif"
        self.gender = NSBundle.mainBundle().bundlePath + "/" + "Male.gif"
        self.signature = ""
    }
    convenience init(userID: Int) {
        let userInfo = globalDataProcessor.GetUserByID(userID)
        self.init(userInfo: userInfo)
    }
    
}