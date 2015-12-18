//
//  TopicListViewController.swift
//  CC98
//
//  Created by CCNT on 12/15/15.
//  Copyright © 2015 Orpine. All rights reserved.
//




import Foundation
import UIKit
import SwiftyJSON
import JLToast

class TopicListViewController:UITableViewController{
    
    var loading:Bool = false
    var board:CC98Board?
    var topics = Array<CC98Topic>()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(true)
        self.title=board?.name
     
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //        tableView.separatorStyle = .None
        self.tableView.addHeaderWithCallback{
            self.loadData(true)
        }
        self.tableView.addFooterWithCallback{
            
            if(self.topics.count>0) {
                self.loadData(false)
            }
        }
        self.tableView.headerBeginRefreshing()
    }
    
    func loadData(isPullRefresh:Bool){
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            if self.loading {
                return
            }
            self.loading = true
            let topics=self.board!.loadTopics(isPullRefresh)
            self.loading = false
            
            if(isPullRefresh){
                self.tableView.headerEndRefreshing()
            }
            else{
                self.tableView.footerEndRefreshing()
            }
            if topics.count==0 && isPullRefresh{
                JLToast.makeText("网络异常，请检查网络设置！", duration: textDuration).show()
//                let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
//                alert.show()
                return
            }
            
            if(topics.count==0){
                return
            }
            
            if(isPullRefresh){
                
                self.topics.removeAll(keepCapacity: false)
            }
            
            
            for it in topics {
                self.topics.append(it)
            }
            
            if isPullRefresh {
                self.tableView.reloadData()
            } else {
                self.tableView.beginUpdates()
                for i in (self.topics.count - topics.count)...(self.topics.count - 1) {
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .None)
                }
                self.tableView.endUpdates()
                for i in (self.topics.count - topics.count)...(self.topics.count - 1) {
                    self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .None)
                }
            }
//        }
        
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return topics.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! TopicCell
        let cell = tableView.dequeueReusableCellWithIdentifier("topicCell1", forIndexPath: indexPath) as! TopicCell1
        let topic=topics[indexPath.row]
        cell.title.text=topic.title
        if topic.author==""{
            cell.authorName.text="匿名"
        }
        else{
            cell.authorName.text=topic.author
        }
        
        cell.createTime.text=topic.time
        cell.updateConstraintsIfNeeded()
        // cell.contentView.backgroundColor = UIColor.grayColor()
        
        // cell.selectedBackgroundView = cell.containerView
        
        
        return cell
    }
    var prototypeCell:TopicCell1?
    
    private func configureCell(cell:TopicCell1,indexPath: NSIndexPath,isForOffscreenUse:Bool){
        if topics.count>0{
            let topic=topics[indexPath.row]
            cell.title.text=topic.title
            if topic.author==""{
                cell.authorName.text="匿名"
            }
            else{
                cell.authorName.text=topic.author
            }
            cell.createTime.text=topic.time
        }
        
        cell.selectionStyle = .None;
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if prototypeCell == nil
        {
            self.prototypeCell = self.tableView.dequeueReusableCellWithIdentifier("topicCell1") as? TopicCell1
        }
        
        
        
        
        self.configureCell(prototypeCell!, indexPath: indexPath, isForOffscreenUse: false)
        
        self.prototypeCell?.setNeedsUpdateConstraints()
        self.prototypeCell?.updateConstraintsIfNeeded()
        self.prototypeCell?.setNeedsLayout()
        self.prototypeCell?.layoutIfNeeded()
        
        
        let size = self.prototypeCell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        
        return size.height;
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "topicDetail1" {
            
            
            let view = segue.destinationViewController as! TopicDetailController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let topic = self.topics[indexPath!.row]
            view.topic=topic
            
            
            
        }
    }
}