//
//  MeViewController.swift
//  CC98
//
//  Created by Orpine on 12/18/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import UIKit
import JLToast
import p2_OAuth2
import SwiftyJSON

class MeViewController: UITableViewController {
    var meInfo: CC98User?

    override func viewDidLoad() {
        self.title="Me"
        oauth.authConfig.authorizeContext = self
        oauth.afterAuthorizeOrFailure = { wasFailure, error in
            if (wasFailure == false) {
                let req = oauth.request(forURL: NSURL(string: "https://api.cc98.org/me")!)
                req.addValue("Application/json", forHTTPHeaderField: "Accept")
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(req) { data, response, error in
                    if nil != error {
                        JLToast.makeText("获取用户信息失败！").show()
                    }
                    else {
                        let data = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        let json = JSON(data)
                        self.meInfo = CC98User(userInfo: json)
                        // todo
                        // update info in view
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            self.tableView.reloadData()
                        }
                    }
                }
                task.resume()
            }
        }
        oauth.authorize()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==1{
            if meInfo == nil {
                return 0
            }
            return meInfo!.accountInfo.count
        }
        else{
            if meInfo == nil {
                return 0
            }
            return meInfo!.userInfo.count
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier("userProfileCell", forIndexPath: indexPath)as! MeCell
        
        if meInfo != nil{
            if indexPath.section==1{
                cell.title.text=meInfo!.accountInfo[indexPath.row]
                cell.detail.text=meInfo!.accountInfoDetail[indexPath.row]
            }
            else{
                cell.title.text=meInfo!.userInfo[indexPath.row]
                cell.detail.text=meInfo!.userInfoDetail[indexPath.row]
            }
        }
       return cell
    }
    
    
    
}