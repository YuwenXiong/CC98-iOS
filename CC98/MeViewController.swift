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
                        print(json)
                        self.meInfo = CC98User(userInfo: json)
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
    }
}