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
        //        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
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
                    if nil != error {
                        JLToast.makeText("获取用户信息失败！").show()
                    }
                    else {
                        let data = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        let json = JSON(data)
                        print(json)
                        self.boardsJson=json
                        // todo
                        // update info in view
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                           self.tableView.reloadData()
                        })
                    }
                }
                task.resume()
            }
        }
        oauth.authorize()
        self.loading = false
        
        
        self.tableView.headerEndRefreshing()
        
        if customBoards.count==0 {
            JLToast.makeText("网络异常，请检查网络设置！", duration: textDuration).show()
            //                let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
            //                alert.show()
            return
        }
        
        
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
        if board.isCategory{
            let boardView:BoardViewController=UITools.GetViewController("boardViewController")
            boardView.thisBoard=board
            boardView.isRoot=false
            self.navigationController?.pushViewController(boardView, animated: true)
        }
        else{
            let topicView:TopicListViewController=UITools.GetViewController("topicListViewController")
            topicView.board=board
            self.navigationController?.pushViewController(topicView, animated: true)
        }
        
        //TODO
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! TopicCell
        let cell = tableView.dequeueReusableCellWithIdentifier("BoardCell", forIndexPath: indexPath) as! BoardCell
    //    cell.board=globalDataProcessor.GetBoardInfo(boardsJson[indexPath.row])
        cell.boardName.text=cell.board!.name
        
        cell.updateConstraintsIfNeeded()
        // cell.contentView.backgroundColor = UIColor.grayColor()
        
        // cell.selectedBackgroundView = cell.containerView
        
        
        return cell
    }
    



}