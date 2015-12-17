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
    var posts = Array<CC98Post>()
    var postContent = Array<String>()
    var postImgs = Array<Array<String>>()
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
            self.postHeight.removeAll(keepCapacity: false)
            self.postContent.removeAll(keepCapacity: false)
            self.postImgs.removeAll(keepCapacity: false)
        }
        
        
        for it in posts {
            self.posts.append(it)
            self.postHeight.append(0)
            self.postContent.append("")
            self.postImgs.append(Array<String>())
        }
        
        if isPullRefresh {
            self.tableView.reloadData()
        } else {
            self.tableView.beginUpdates()
            for i in (self.posts.count - posts.count)...(self.posts.count - 1) {
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .None)
            }
            self.tableView.endUpdates()
            for i in (self.posts.count - posts.count)...(self.posts.count - 1) {
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .None)
            }
        }
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
        return postHeight[indexPath.row]+10
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        let height = CGFloat((webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")! as NSString).doubleValue + 10)
//        print(postContent[webView.tag])
        
        if (postHeight[webView.tag] == height) {
            return
        }
        postHeight[webView.tag] = height
//        postContent[webView.tag] =
        postImgs[webView.tag] = globalDataProcessor.GetImageUrls(webView.stringByEvaluatingJavaScriptFromString("document.body.getElementsByClassName('post-content')[0].innerHTML")!)
        print(postImgs)
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: webView.tag, inSection: 0)], withRowAnimation: .None)
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL!.absoluteString.hasPrefix("http") {
            print(request.URL?.absoluteString)
            return false
        } else {
            return true
        }
    }
}