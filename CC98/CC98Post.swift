//
//  CC98Post.swift
//  CC98
//
//  Created by Orpine on 12/10/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import SwiftyJSON

class CC98Post {
    let title: String, author: CC98User, postTime: String, floor: String
    var content: String
    init(postInfo: JSON) {
        self.title = postInfo["title"].stringValue
        self.postTime = postInfo["time"].stringValue.stringByReplacingOccurrencesOfString("T", withString: " ")
        if postInfo["isAnomynous"].boolValue {
            self.author = CC98User()
        }
        else {
            self.author = CC98User(userID: postInfo["userId"].intValue)
        }
        self.floor = postInfo["floor"].stringValue
        self.content = postInfo["content"].stringValue.stringByReplacingOccurrencesOfString("\r\n", withString: "<br>")
        self.content = globalDataProcessor.ParsePostContent(self)
    }
}