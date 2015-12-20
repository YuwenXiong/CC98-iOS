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
import NYTPhotoViewer
import JLToast

class TopicDetailController:UITableViewController, UIWebViewDelegate, NYTPhotosViewControllerDelegate {
    
    var loading:Bool = false
    var topic:CC98Topic?
    var posts = Array<CC98Post>()
    var postContent = Array<String>()
    var postImgs = Array<Array<ExamplePhoto>>()
    var postImgUrls = Array<Array<String>>()
    var postHeight = Array<CGFloat>()
    let photosProvider = PhotosProvider()
    var photosViewController: NYTPhotosViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.opaque = false
//        self.tableView.backgroundColor = UIColor.clearColor()
//        self.tableView.estimatedRowHeight = 150;
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
//        loadData(true)
        self.title=topic?.title
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
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            if self.loading {
                return
            }
            self.loading = true
            let posts=self.topic!.loadPosts(isPullRefresh)
            self.loading = false
            
            if(isPullRefresh){
                self.tableView.headerEndRefreshing()
            }
            else{
                self.tableView.footerEndRefreshing()
            }
            if posts.count==0 && isPullRefresh{
                JLToast.makeText("网络异常，请检查网络设置！", duration: textDuration).show()
                //            let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
                //            alert.show()
                return
            }
            
            if(posts.count==0){
                return
            }
            
            if(isPullRefresh){
                self.posts.removeAll(keepCapacity: false)
                self.postHeight.removeAll(keepCapacity: false)
                self.postContent.removeAll(keepCapacity: false)
                self.postImgUrls.removeAll(keepCapacity: false)
                self.postImgs.removeAll(keepCapacity: false)
            }
            
            
            for it in posts {
                self.posts.append(it)
                self.postHeight.append(0)
                self.postContent.append("")
                self.postImgs.append(Array<ExamplePhoto>())
                self.postImgUrls.append(Array<String>())
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
        let height = CGFloat((webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")! as NSString).doubleValue + 10)
//        print(postContent[webView.tag])
        
        if (postHeight[webView.tag] == height) {
            return
        }
        postHeight[webView.tag] = height
        postImgUrls[webView.tag] = globalDataProcessor.GetImageUrls(webView.stringByEvaluatingJavaScriptFromString("document.body.getElementsByClassName('post-content')[0].innerHTML")!)
        postImgs[webView.tag] = self.photosProvider.getImages(postImgUrls[webView.tag])
        
//        print(postImgs)
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: webView.tag, inSection: 0)], withRowAnimation: .None)
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL!.absoluteString.hasPrefix("http") {
            print(request.URL?.absoluteString)
            if (postImgUrls[webView.tag].contains((request.URL?.absoluteString)!)) {
                self.photosViewController = NYTPhotosViewController(photos: postImgs[webView.tag])
                self.photosViewController!.delegate = self
                self.presentViewController(photosViewController!, animated: true, completion: nil)
            }
            return false
        } else {
            return true
        }
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController!, handleActionButtonTappedForPhoto photo: NYTPhoto!) -> Bool {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            
            let shareActivityViewController = UIActivityViewController(activityItems: [photo.image!], applicationActivities: nil)
            
            shareActivityViewController.completionWithItemsHandler = {(activityType: String?, completed: Bool, items: [AnyObject]?, error: NSError?) in
                if completed {
                    photosViewController.delegate?.photosViewController!(photosViewController, actionCompletedWithActivityType: activityType!)
                }
            }
            
            shareActivityViewController.popoverPresentationController?.barButtonItem = photosViewController.rightBarButtonItem
            photosViewController.presentViewController(shareActivityViewController, animated: true, completion: nil)
            
            return true
        }
        
        return false
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController!, referenceViewForPhoto photo: NYTPhoto!) -> UIView! {
        //        if photo as? ExamplePhoto == photos[NoReferenceViewPhotoIndex] {
        //            /** Swift 1.2
        //             *  if photo as! ExamplePhoto == photos[PhotosProvider.NoReferenceViewPhotoIndex]
        //             */
        //            return nil
        //        }
        return nil
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController!, loadingViewForPhoto photo: NYTPhoto!) -> UIView! {
        //        if photo as! ExamplePhoto == photos[CustomEverythingPhotoIndex] {
        //            let label = UILabel()
        //            label.text = "Custom Loading..."
        //            label.textColor = UIColor.greenColor()
        //            return label
        //        }
        return nil
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController!, captionViewForPhoto photo: NYTPhoto!) -> UIView! {
        //        if photo as! ExamplePhoto == photos[CustomEverythingPhotoIndex] {
        //            let label = UILabel()
        //            label.text = "Custom Caption View"
        //            label.textColor = UIColor.whiteColor()
        //            label.backgroundColor = UIColor.redColor()
        //            return label
        //        }
        return nil
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController!, didNavigateToPhoto photo: NYTPhoto!, atIndex photoIndex: UInt) {
        print("Did Navigate To Photo: \(photo) identifier: \(photoIndex)")
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController!, actionCompletedWithActivityType activityType: String!) {
        print("Action Completed With Activity Type: \(activityType)")
    }
    
    func photosViewControllerDidDismiss(photosViewController: NYTPhotosViewController!) {
        print("Did dismiss Photo Viewer: \(photosViewController)")
    }
    
}