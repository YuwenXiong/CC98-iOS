//
//  CC98Board.swift
//  CC98
//
//  Created by Orpine on 12/13/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation

class CC98Board {
    let ID: Int, parent: Int, name: String, isCategory: Bool, subBoardCount: Int, todayPosts: Int
    var from = 0, to = 9
    var boards = Array<CC98Board>()
    init(ID: Int) {
        let data = globalDataProcessor.GetBoardInfo(ID)
        self.ID = ID
        self.parent = data["parentId"].intValue
        self.name = data["name"].stringValue
        self.isCategory = data["isCategory"].boolValue
        self.subBoardCount = data["childBoardCount"].intValue
        self.todayPosts = data["todayPostCount"].intValue
    }
    func GetSubBoards() {
        if self.subBoardCount > 0 {
            self.boards.removeAll()
            let subBoardData = globalDataProcessor.GetSubBoards(self.ID)
            for i in 0...self.subBoardCount-1 {
                self.boards.append(CC98Board(ID: subBoardData[i]["id"].intValue))
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