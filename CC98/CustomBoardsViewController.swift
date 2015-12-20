//
//  BookMarkViewController.swift
//  CC98
//
//  Created by CCNT on 12/18/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import UIKit
import JLToast
import p2_OAuth2
import SwiftyJSON

class CustomBoardsViewController:UITableViewController{
    var meInfo: CC98User?
    var loading:Bool=false
    var customBoards=Array<CC98Board>()
    var boardsJson:SwiftyJSON.JSON = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //        tableView.separatorStyle = .None
        self.tableView.addHeaderWithCallback{
            self.loadData()
        }
        
        self.tableView.headerBeginRefreshing()
    }
    
    func loadData(){
        if self.loading {
            return
        }
        self.loading = true
        oauth.authConfig.authorizeContext = self
        oauth.afterAuthorizeOrFailure = { wasFailure, error in
            if (wasFailure == false) {
                let req = oauth.request(forURL: NSURL(string: "https://api.cc98.org/me/CustomBoards")!)
                req.addValue("Application/json", forHTTPHeaderField: "Accept")
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(req) { data, response, error in
                    if error != nil {
                        self.boardsJson=""
                        self.loading = false
                        self.tableView.headerEndRefreshing()
                        self.tableView.reloadData()
                        print(error)
                        JLToast.makeText("获取用户信息失败！").show()
                    }
                    else {
                        let data = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        let json = JSON(data)
                        self.boardsJson=json
                        self.customBoards.removeAll(keepCapacity: false)
                        for _ in 0...json.count-1 {
                            self.customBoards.append(CC98Board(data: ""))
                        }
                        self.loading = false
                        self.tableView.headerEndRefreshing()
                        
                        if self.boardsJson.count==0 {
                            JLToast.makeText("网络异常，请检查网络设置！", duration: textDuration).show()
                            return
                        }
                        self.tableView.reloadData()
                    }
                }
                task.resume()
            } else {
                self.boardsJson=""
                self.loading = false
                self.tableView.headerEndRefreshing()
                self.tableView.reloadData()
                JLToast.makeText("获取用户信息失败！").show()
            }
        }
        oauth.authorize()
        
        
        return

    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return boardsJson.count
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let board = customBoards[indexPath.row]
//        if board.isCategory{
//            let boardView:BoardViewController=UITools.GetViewController("boardViewController")
//            boardView.thisBoard=board
//            boardView.isRoot=false
//            self.navigationController?.pushViewController(boardView, animated: true)
//        }
//        else{
            let topicView:TopicListViewController=UITools.GetViewController("topicListViewController")
            topicView.board=board
            self.navigationController?.pushViewController(topicView, animated: true)
//        }
        
        //TODO
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! TopicCell
        let cell = tableView.dequeueReusableCellWithIdentifier("BoardCell", forIndexPath: indexPath) as! BoardCell
        if boardsJson == nil {
            return cell
        }
        if self.customBoards[indexPath.row].ID == 0 {
            self.customBoards[indexPath.row] = CC98Board(data: globalDataProcessor.GetBoardInfo(boardsJson[indexPath.row].intValue))
        }
        cell.board = self.customBoards[indexPath.row]
//        cell.board=
//        if cell.board == nil {
//            return cell
//        }
        cell.boardName.text=cell.board!.name
        
        cell.updateConstraintsIfNeeded()
        // cell.contentView.backgroundColor = UIColor.grayColor()
        
        // cell.selectedBackgroundView = cell.containerView
        
        
        return cell
    }
    



}