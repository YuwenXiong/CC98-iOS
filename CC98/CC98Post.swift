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
    init(postInfo: JSON, dataProcessor: DataProcessor) {
        self.title = postInfo["title"].stringValue
        self.postTime = postInfo["time"].stringValue.stringByReplacingOccurrencesOfString("T", withString: " ")
        self.author = CC98User(userID: postInfo["userId"].intValue)
        self.floor = postInfo["floor"].stringValue
        self.content = postInfo["content"].stringValue
        self.content = dataProcessor.ParsePostContent(self)
//        print(self.content)
    }
}