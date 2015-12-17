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
    var ID: Int, title: String, author: String, time: String, boardName: String, boardID: Int
    var from = 0, to = 0
    init(ID: Int) {
        globalDataProcessor.GetTopicInfo(ID, callback: { (data: JSON) -> Void in {
                self.ID = ID
                self.title = data["title"].stringValue
                self.author = data["authorName"].stringValue
                self.time = data["createTime"].stringValue.stringByReplacingOccurrencesOfString("T", withString: " ")
                self.boardID = data["boardId"].intValue
                self.boardName = globalDataProcessor.GetBoardInfo(self.boardID)["name"].stringValue
                self.from = 0
                self.to = 9
            }
        })
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