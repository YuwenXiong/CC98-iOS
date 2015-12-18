//
//  CC98Topic.swift
//  CC98
//
//  Created by Orpine on 12/13/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import SwiftyJSON

class CC98Topic {
    var ID: Int = 0, title: String = "", author: String = "", time: String = "", boardName: String = "", boardID: Int = 0
    var from = 0, to = 0
    init(ID: Int) {
//        var flag = false
//        let sem = dispatch_semaphore_create(0)
        globalDataProcessor.GetTopicInfo(ID, callback: { (data: JSON) -> Void in
                self.ID = data["id"].intValue
                self.title = data["title"].stringValue
                self.author = data["authorName"].stringValue
                self.time = data["createTime"].stringValue.stringByReplacingOccurrencesOfString("T", withString: " ")
                self.boardID = data["boardId"].intValue
                self.boardName = globalDataProcessor.GetBoardInfo(self.boardID)["name"].stringValue
                self.from = 0
                self.to = 9
//            dispatch_semaphore_signal(sem)
//            flag = true
//                print(self.title)
        })
//        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)
//        while (!flag) {
//            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
//        }
    }
    func loadPosts(reset: Bool = false) -> Array<CC98Post> {
        if reset {
            from = 0
            to = 9
        }
//        globalDataProcessor.GetTopicInfo(<#T##topicID: Int##Int#>, callback: <#T##(JSON) -> Void#>)
        let ret = globalDataProcessor.GetTopicPost(ID, from: from, to: to)
        from += 10
        to += 10
        return ret
    }
    
}