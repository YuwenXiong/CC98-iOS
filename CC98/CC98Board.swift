//
//  CC98Board.swift
//  CC98
//
//  Created by Orpine on 12/13/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import SwiftyJSON

class CC98Board {
    let ID: Int, parent: Int, name: String, isCategory: Bool, todayPosts: Int
    var from = 0, to = 9
    var boards = Array<CC98Board>()
    init(data: JSON) {
        self.ID = data["id"].intValue
        self.parent = data["parentId"].intValue
        self.name = data["name"].stringValue
        self.isCategory = data["childBoardCount"].intValue != 0
        self.todayPosts = data["todayPostCount"].intValue
    }
    func GetSubBoards(refresh:Bool) {
        if self.isCategory {
            self.boards.removeAll(keepCapacity: false)
            let subBoardData = globalDataProcessor.GetSubBoards(self.ID,refresh:refresh)
            if subBoardData.count != 0 {
                for i in 0...subBoardData.count-1 {
                    self.boards.append(CC98Board(data: subBoardData[i]))
                }
            }
        }
    }
    func loadTopics(reset:Bool=false) -> Array<CC98Topic> {
        if reset {
            from = 0
            to = 9
        }
        let ret = globalDataProcessor.GetBoardTopic(ID, from: from, to: to)
        from += 10
        to += 10
        return ret
    }
}