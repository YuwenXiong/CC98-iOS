//
//  DataProcessor.swift
//  CC98
//
//  Created by Orpine on 11/13/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Haneke
import JLToast

class DataProcessor {
    var json: SwiftyJSON.JSON = nil
    var networkStatus: String = ""
    let cache = Shared.JSONCache
    func SetNetworkStatus(networkStatus: String) {
        self.networkStatus = networkStatus
        let VPN_Swith = userDefaults.valueForKey("VPN_Switch")
        if networkStatus == "Cellular" && VPN_Swith != nil && (VPN_Swith as! Bool ) {
            print(userDefaults.valueForKey("VPN_Username") as! String)
            print(userDefaults.valueForKey("VPN_Password") as! String)
            baseURL = "https://rvpn.zju.edu.cn/web/1/http/0/api.cc98.org:80/"
            baseURLS = "https://rvpn.zju.edu.cn/web/1/http/0/api.cc98.org:80/"
            Alamofire.request(.POST, "https://rvpn.zju.edu.cn/por/login_psw.csp", parameters: ["svpn_name": userDefaults.valueForKey("VPN_Username") as! String, "svpn_password": userDefaults.valueForKey("VPN_Password") as! String], headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseData {
                response in
                NSLog("Success: \(response.response)")
                NSLog("Success: \(response.request)")
            }
        } else if networkStatus == "WiFi" {
            baseURL = "http://api.cc98.org/"
            baseURLS = "https://api.cc98.org/"
        }
    }
    func GetJSON(URL: String, refresh: Bool) -> SwiftyJSON.JSON {

        if refresh {
            self.cache.remove(key: URL)
        }
        
        var flag = false
        self.cache.fetch(URL: NSURL(string: URL)!).onSuccess {
            JSON in
            self.json = SwiftyJSON.JSON(data: JSON.asData())
            flag = true
            } .onFailure {
                failer in
                flag = true
                self.json = JSON("")
        }
        while (!flag) {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
        return self.json
    }
    
    // pass
    func GetHotTopic(refresh: Bool) -> Array<CC98Topic> {
        let topicsJSON = GetJSON(baseURL + "Topic/Hot", refresh: refresh)
        var topics = Array<CC98Topic>()
        if topicsJSON.count > 0 {
            for i in 0...topicsJSON.count-1 {
                topics.append(CC98Topic(data: topicsJSON[i]))
            }
        }
        return topics
    }
    
    // pass
    func GetBoardTopic(boardID: Int, from: Int, to: Int) -> Array<CC98Topic> {
        let topicsJSON = GetJSON(baseURL + "Topic/Board/\(boardID)?from=\(from)&to=\(to)", refresh: true)
        var topics = Array<CC98Topic>()
        if topicsJSON.count > 0 {
            for i in 0...topicsJSON.count-1 {
                topics.append(CC98Topic(data: topicsJSON[i]))
            }
        }
        return topics
    }
    
    // pass
//    func GetTopicInfo(topicID: Int) -> SwiftyJSON.JSON {
//        return GetJSON(baseURL + "Topic/\(topicID)")
//    }
    
    // pass
    func GetTopicPost(topicID: Int, from: Int, to: Int,refresh:Bool) -> Array<CC98Post> {
        let postsJSON = GetJSON(baseURL + "Post/Topic/\(topicID)?from=\(from)&to=\(to)",refresh:refresh)
        var posts = Array<CC98Post>()
        if postsJSON.count > 0 {
            for i in 0...postsJSON.count-1 {
                posts.append(CC98Post(postInfo: postsJSON[i]))
            }
        }
        return posts
    }
    
    // pass
//    func GetPost(postID: Int) -> CC98Post {
//        return CC98Post(postInfo: GetJSON(baseURL + "Post/\(postID)"))
//    }
    // User
    // pass
//    func GetUserByName(userName: String) -> SwiftyJSON.JSON {
//        return GetJSON(baseURL + "User/Name/\(userName)")
//    }
    
    // pass
    func GetUserByID(userID: Int) -> SwiftyJSON.JSON {
        return GetJSON(baseURL + "User/\(userID)", refresh: true)
    }
    
    
    // Board
    // pass
    func GetRootBoard(refresh:Bool) -> Array<CC98Board> {
        let boardsJSON = GetJSON(baseURL + "Board/Root",refresh:refresh)
        var boards = Array<CC98Board>()
        if boardsJSON.count > 0 {
            for i in 0...boardsJSON.count-1 {
                boards.append(CC98Board(data: boardsJSON[i]))
            }
        }
        return boards
    }
    // pass
    func GetSubBoards(boardID: Int,refresh:Bool) -> SwiftyJSON.JSON {
        return GetJSON(baseURL + "Board/\(boardID)/Subs",refresh: refresh)
    }
    // pass
    func GetBoardInfo(boardID: Int) -> SwiftyJSON.JSON {
        return GetJSON(baseURL + "Board/\(boardID)", refresh: false)
    }
    
    //    func GetBoard(boardID: Int) -> CC98Board {
    //        return CC98Board(ID: boardID)
    //    }
    
    func ParsePostContent(post: CC98Post) -> String {
        var content = post.content
        var avatar = post.author.avatar
        var signature = post.author.signature
        content = content.stringByReplacingOccurrencesOfString("[upload=jpg,1]", withString: "[upload=jpg]")
        content = content.stringByReplacingOccurrencesOfString("[upload=jpeg,1]", withString: "[upload=jpeg]")
        content = content.stringByReplacingOccurrencesOfString("[upload=gif,1]", withString: "[upload=gif]")
        content = content.stringByReplacingOccurrencesOfString("[upload=bmp,1]", withString: "[upload=bmp]")
        content = content.stringByReplacingOccurrencesOfString("[upload=png,1]", withString: "[upload=png]")
        if networkStatus == "Cellular" {
            content = content.stringByReplacingOccurrencesOfString("http://file.cc98.org", withString: "https://rvpn.zju.edu.cn/web/1/http/0/file.cc98.org")
            avatar = avatar.stringByReplacingOccurrencesOfString("http://file.cc98.org", withString: "https://rvpn.zju.edu.cn/web/1/http/0/file.cc98.org")
            avatar = avatar.stringByReplacingOccurrencesOfString("http://www.cc98.org", withString: "https://rvpn.zju.edu.cn/web/1/http/0/www.cc98.org")
            signature = signature.stringByReplacingOccurrencesOfString("http://file.cc98.org", withString: "https://rvpn.zju.edu.cn/web/1/http/0/file.cc98.org")
            signature = signature.stringByReplacingOccurrencesOfString("http://www.cc98.org", withString: "https://rvpn.zju.edu.cn/web/1/http/0/www.cc98.org")
        }
        
        let htmlPath = NSBundle.mainBundle().pathForResource("CC98PostListWebPage", ofType: "html")
        let htmlContent = try! NSMutableString(contentsOfFile: htmlPath!, encoding: NSUTF8StringEncoding)
        let frontRange = htmlContent.rangeOfString("$foreach$")
        let frontPart = htmlContent.substringToIndex(frontRange.location)
        
        let endRange = htmlContent.rangeOfString("$endeach$")
        let endPart = htmlContent.substringFromIndex(endRange.location + endRange.length)
        
        let middleRangeLocation = frontRange.location + frontRange.length
        let middleRange = NSMakeRange(middleRangeLocation, endRange.location - middleRangeLocation)
        let middlePart = htmlContent.substringWithRange(middleRange)
        
        let finalText = NSMutableString(string: frontPart)
        
        let htmlText = NSMutableString(string: middlePart)
        htmlText.replaceOccurrencesOfString("${title}", withString: post.title, options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(0, htmlText.length))
        htmlText.replaceOccurrencesOfString("${author}", withString: post.author.nickName, options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(0, htmlText.length))
        htmlText.replaceOccurrencesOfString("${gender}", withString: post.author.gender, options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(0, htmlText.length))
        htmlText.replaceOccurrencesOfString("${time}", withString: post.postTime, options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(0, htmlText.length))
        htmlText.replaceOccurrencesOfString("${floor}", withString: post.floor, options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(0, htmlText.length))
        htmlText.replaceOccurrencesOfString("${avatar}", withString: avatar, options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(0, htmlText.length))
        htmlText.replaceOccurrencesOfString("${content}", withString: "<div id=\"ubbcode1\">" + content + "</div><script>searchubb('ubbcode1',1,'tablebody1');</script>", options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(0, htmlText.length))
        htmlText.replaceOccurrencesOfString("${i}", withString: post.floor, options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(0, htmlText.length))
        finalText.appendString(htmlText as String)
        if signature != "" {
            finalText.appendString("<div class=\"post-content\">-------------------------------------------------------</div><div class=\"post-content\">")
            finalText.appendString("<div id=\"ubbcode2\">" + signature + "</div><script>searchubb('ubbcode2', 1, 'tablebody1');</script></div>")
        }
        finalText.appendString(endPart)
        return finalText as String
    }
    
    func GetImageUrls(content: String) -> Array<String> {
        var result = Array<String>()
        do {
            
            var begin = 0
            let pattern1 = "(http(s?):)([/|.|\\w|\\s])*\\.(?:jpg|gif|png)"
            let regex1 = try NSRegularExpression(pattern: pattern1, options: NSRegularExpressionOptions.CaseInsensitive)
            
            var res1 = regex1.rangeOfFirstMatchInString(content, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(begin,content.characters.count))
            while (true) {
                let myNSString = content as NSString
                if (res1.location + res1.length >= content.characters.count) {
                    break;
                }
                result.append(myNSString.substringWithRange(NSMakeRange(res1.location, res1.length)))
                begin = res1.location+res1.length
                if (begin >= content.characters.count) {
                    break
                }
                
                res1 = regex1.rangeOfFirstMatchInString(content, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(begin,content.characters.count-begin))
                if (res1.length == 0) {
                    break
                }
            }
        }
        catch {
            print(error)
        }
        return removeDuplicates(result)
    }
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
}