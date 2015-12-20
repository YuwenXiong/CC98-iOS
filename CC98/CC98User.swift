//
//  CC98User.swift
//  CC98
//
//  Created by Orpine on 12/10/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import SwiftyJSON

class CC98User {
    let nickName: String, avatar: String, gender: String, signature: String
    var accountInfo=Array<String>(),accountInfoDetail=Array<String>(),userInfo=Array<String>(),userInfoDetail=Array<String>()
    init(userInfo: JSON) {
        self.nickName = userInfo["name"].stringValue
        let avatar = userInfo["portraitUrl"].stringValue
        self.avatar = avatar.hasPrefix("PresetFace") ? siteURL + avatar : avatar
        self.gender = NSBundle.mainBundle().bundlePath + "/" + (userInfo["isOnline"].boolValue ? "" : "of") + (userInfo["gender"] == 0 ? "Male.gif" : "FeMale.gif")
        self.signature = userInfo["signatureCode"].stringValue
        add(true,title:"用户名",detail: userInfo["name"].stringValue)
        add(true,title:"最后登录",detail:userInfo["lastLogOnTime"].stringValue.stringByReplacingOccurrencesOfString("T", withString: " "))
        add(true,title:"注册时间",detail:userInfo["registerTime"].stringValue.stringByReplacingOccurrencesOfString("T", withString: " "))
        add(true,title:"用户组别",detail: userInfo["groupName"].stringValue)
        add(true,title:"用户等级",detail: userInfo["level"].stringValue)
        add(true,title:"发帖总数",detail: userInfo["postCount"].stringValue)
        add(false,title:"QQ",detail: userInfo["qq"].stringValue)
        add(false,title:"MSN",detail: userInfo["msn"].stringValue)
          add(false,title:"生日",detail: userInfo["birthday"].stringValue)
        let temp=(userInfo["gender"] == 0 ? "男" : "女")
        add(false,title:"性别",detail:temp)
    }
    init() {
        self.nickName = ""
        self.avatar = "face/anonymous.gif"
        self.gender = NSBundle.mainBundle().bundlePath + "/" + "Male.gif"
        self.signature = ""
    }
    convenience init(userID: Int) {
        let userInfo = globalDataProcessor.GetUserByID(userID)
        self.init(userInfo: userInfo)
    }
    func add(AorU:Bool,title:String,detail:String){
        if(AorU){
            accountInfo.append(title)
            if(detail != ""){
                accountInfoDetail.append(detail)
            }
            else{
                accountInfoDetail.append("未知")
            }
        }
        else{
            userInfo.append(title)
            if(detail != ""){
                userInfoDetail.append(detail)
            }
            else{
                userInfoDetail.append("未知")
            }
        }
    }
    
}