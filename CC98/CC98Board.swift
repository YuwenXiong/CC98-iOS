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
    var boards = Array<CC98Board>()
    init(ID: Int) {
        let data = globalDataProcessor.GetBoardInfo(ID)
        self.ID = ID
        self.parent = data["parentId"].intValue
        self.name = data["name"].stringValue
        self.isCategory = data["isCategory"].boolValue
        self.subBoardCount = data["childBoardCount"].intValue
        self.todayPosts = data["todayPostCount"].intValue
        if self.subBoardCount > 0 {
            let subBoardData = globalDataProcessor.GetSubBoards(self.ID)
            for i in 0...self.subBoardCount-1 {
                self.boards.append(CC98Board(ID: subBoardData[i]["id"].intValue))
            }
        }
    }
}