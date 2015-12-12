//
//  CC98Topic.swift
//  CC98
//
//  Created by Orpine on 12/13/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation

class CC98Topic {
    let ID: Int, dataProcessor = DataProcessor(), title: String, author: String, time: String
    var from = 0, to = 0
    init(ID: Int) {
        let data = dataProcessor.GetTopicInfo(ID)
        self.ID = ID
        self.title = data["title"].stringValue
        self.author = data["author"].stringValue
        self.time = data["time"].stringValue.stringByReplacingOccurrencesOfString("T", withString: " ");
        self.from = 0
        self.to = 9
    }
    func loadPosts() -> Array<CC98Post> {
        let ret = dataProcessor.GetTopicPost(ID, from: from, to: to)
        from += 10
        to += 10
        return ret
    }
}