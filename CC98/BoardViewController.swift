//
//  BoardViewController.swift
//  CC98
//
//  Created by CCNT on 12/15/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import UIKit

class BoardViewController:UITableViewController{
    var subBoards=Array<CC98Board>()
    var thisBoard:CC98Board?
    var isRoot:Bool=true
    var loading:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData(true)
        
        self.tableView.estimatedRowHeight = 120;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //        tableView.separatorStyle = .None
        self.tableView.addHeaderWithCallback{
            self.loadData(true)
        }
        self.tableView.headerBeginRefreshing()
    }
    func loadData(isPullRefresh:Bool){
        if isRoot{
            subBoards=globalDataProcessor.GetRootBoard();
        }
        else{
            thisBoard!.GetSubBoards();
            subBoards=thisBoard!.boards
        }
        self.loading = false
        
        if(isPullRefresh){
            self.tableView.headerEndRefreshing()
        }
        else{
            self.tableView.footerEndRefreshing()
        }
        if subBoards.count==0 {
            let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
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
           let boardView=BoardViewController()
            boardView.thisBoard=board
            boardView.isRoot=false
            self.navigationController?.pushViewController(boardView, animated: true)
        }
        else{
            
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