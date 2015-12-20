//
//  BoardViewController.swift
//  CC98
//
//  Created by CCNT on 12/15/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import UIKit
import JLToast

class BoardViewController:UITableViewController{
    var subBoards=Array<CC98Board>()
    var thisBoard:CC98Board?
    var isRoot:Bool=true
    var loading:Bool = false
    var loaded = false
    @IBOutlet weak var thisBoardView: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isRoot{
            thisBoardView.title="所有版面"
        }
        else{
            thisBoardView.title=thisBoard?.name
        }
        
        self.tableView.estimatedRowHeight = 120;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //        tableView.separatorStyle = .None
        self.tableView.addHeaderWithCallback{
            self.loadData(true,refresh: true)
        }
//        self.loadData(true,refresh:false)
        self.tableView.headerBeginRefreshing()
    }
    func loadData(isPullRefresh:Bool,refresh:Bool){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            if self.isRoot{
                self.subBoards=globalDataProcessor.GetRootBoard(self.loaded && refresh);
            }
            else{
                self.thisBoard!.GetSubBoards(self.loaded && refresh);
                self.subBoards.removeAll(keepCapacity: false)
                self.subBoards=self.thisBoard!.boards
            }
            self.loading = false
            
            if(isPullRefresh){
                self.tableView.headerEndRefreshing()
            }
            else{
                self.tableView.footerEndRefreshing()
            }
            if self.subBoards.count==0 {
//                let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
//                alert.show()
                JLToast.makeText("网络异常，请检查网络设置！", duration: textDuration).show()
                return
            }
            self.tableView.reloadData()
            self.loaded = true
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let board = subBoards[indexPath.row]
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return subBoards.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! TopicCell
        let cell = tableView.dequeueReusableCellWithIdentifier("BoardCell", forIndexPath: indexPath) as! BoardCell
        cell.board=subBoards[indexPath.row]
        cell.boardName.text=cell.board!.name
        
        cell.updateConstraintsIfNeeded()
        // cell.contentView.backgroundColor = UIColor.grayColor()
        
        // cell.selectedBackgroundView = cell.containerView
        
        
        return cell
    }

}