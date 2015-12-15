//
//  PostDetailController.swift
//  CC98
//
//  Created by CCNT on 12/13/15.
//  Copyright © 2015 Orpine. All rights reserved.
//



import Foundation
import UIKit
import SwiftyJSON

class TopicDetailController:UITableViewController, UIWebViewDelegate{
    
    var loading:Bool = false
    var topic:CC98Topic?
    var posts=Array<CC98Post>()
    var postHeight = Array<CGFloat>()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.opaque = false
//        self.tableView.backgroundColor = UIColor.clearColor()
//        self.tableView.estimatedRowHeight = 150;
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        loadData(true)
        self.tableView.addHeaderWithCallback{
            self.loadData(true)
        }
        self.tableView.addFooterWithCallback{
            
            if(self.posts.count>0) {
                self.loadData(false)
            }
        }
        self.tableView.headerBeginRefreshing()
//        tableView.hidden = false
    }
    
    func loadData(isPullRefresh:Bool){
        if self.loading {
            return
        }
        self.loading = true
        let posts=topic!.loadPosts(isPullRefresh)
        self.loading = false
        
        if(isPullRefresh){
            self.tableView.headerEndRefreshing()
        }
        else{
            self.tableView.footerEndRefreshing()
        }
        if posts.count==0 && isPullRefresh{
            let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        if(posts.count==0){
            return
        }
        
        if(isPullRefresh){
            
            self.posts.removeAll(keepCapacity: false)
        }
        
        
        for it in posts {
            self.posts.append(it)
            self.postHeight.append(0)
        }
        
//        if isPullRefresh {
            self.tableView.reloadData()
//        } else {
//            self.tableView.beginUpdates()
//            for i in (self.posts.count - posts.count)...(self.posts.count - 1) {
//            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .None)
//            }
//            self.tableView.endUpdates()
//            for i in (self.posts.count - posts.count)...(self.posts.count - 1) {
//                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .None)
//            }
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
        return self.posts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostCell
        cell.content=posts[indexPath.row].content
        cell.setView(indexPath.row)
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    override func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return postHeight[indexPath.row]+20
    }

    func webViewDidFinishLoad(webView: UIWebView) {
//        webView.stringByEvaluatingJavaScriptFromString("showAllImages();")
        print(webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight"))
        print(webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight"))
        print(webView.stringByEvaluatingJavaScriptFromString("document.body.clientHeight"))
        print(webView.stringByEvaluatingJavaScriptFromString("document.html.height"))
        let height = CGFloat((webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")! as NSString).doubleValue + 10)
        if (postHeight[webView.tag] == height) {
            return
        }
        postHeight[webView.tag] = height
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: webView.tag, inSection: 0)], withRowAnimation: .None)
    }
    
}