//
//  HotTopicViewController.swift
//  CC98
//
//  Created by CCNT on 12/8/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import JLToast

class HotTopicViewController:UITableViewController{
    
    var loading:Bool = false
    
    var topics = Array<CC98Topic>()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(true)
        
        self.tableView.estimatedRowHeight = 120;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //        tableView.separatorStyle = .None
        self.tableView.addHeaderWithCallback{
            self.loadData(true)
        }
        self.tableView.headerBeginRefreshing()
    }
    
    func loadData(isPullRefresh:Bool){
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.topics=globalDataProcessor.GetHotTopic();
            self.loading = false
            
            if(isPullRefresh){
                self.tableView.headerEndRefreshing()
            }
            else{
                self.tableView.footerEndRefreshing()
            }
            if self.topics.count==0 {
                JLToast.makeText("网络异常，请检查网络设置！", duration: textDuration).show()
//                let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
//                alert.show()
                return
            }
//        }
        
        
        
        
        
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TopicCell
        cell.containerView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue:0.85, alpha: 0.9)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 10
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! TopicCell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TopicCell
        let topic=topics[indexPath.row]
        cell.title.text=topic.title
        if topic.author==""{
            cell.authorName.text="匿名"
        }
        else{
            cell.authorName.text=topic.author
        }
        cell.boardName.text=topic.boardName
        cell.createTime.text=topic.time
        cell.title.adjustsFontSizeToFitWidth=true;
        cell.authorName.adjustsFontSizeToFitWidth=true;
        cell.boardName.adjustsFontSizeToFitWidth=true;
        cell.createTime.adjustsFontSizeToFitWidth=true;
        cell.updateConstraintsIfNeeded()
        
        // cell.contentView.backgroundColor = UIColor.grayColor()
        
        // cell.selectedBackgroundView = cell.containerView
        
        
        return cell
    }
    var prototypeCell:TopicCell?
    
    private func configureCell(cell:TopicCell,indexPath: NSIndexPath,isForOffscreenUse:Bool){
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
            self.prototypeCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as? TopicCell
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
        
        if segue.identifier == "topicDetail" {
            
            
            let view = segue.destinationViewController as! TopicDetailController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let topic = self.topics[indexPath!.row]
            view.topic=topic
            
            
            
        }
    }
}