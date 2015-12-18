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

class DataProcessor {
    var json: SwiftyJSON.JSON = nil
    var networkStatus: String = ""
    let cache = Shared.JSONCache
    func SetNetworkStatus(networkStatus: String) {
        self.networkStatus = networkStatus
        if networkStatus == "Cellular" {
            baseURL = "https://rvpn.zju.edu.cn/web/1/http/0/api.cc98.org:80/"
//            var flag = false
            Alamofire.request(.POST, "https://rvpn.zju.edu.cn/por/login_psw.csp", parameters: ["svpn_name": "3130000829", "svpn_password": "19950723xyw"], headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseData {
                response in
                NSLog("Success: \(response.response)")
                NSLog("Success: \(response.request)")
//                flag = true
            }
//            while (!flag) {
//                NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
//            }
        } else if networkStatus == "WiFi" {
            baseURL = "http://api.cc98.org/"
        }
    }
    func GetJSON(URL: String) -> SwiftyJSON.JSON {
//        if networkStatus == "No Connection" {
//            return "" as JSON
//        }
        var flag = false
//        let semaphore = dispatch_semaphore_create(0)
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.cache.fetch(URL: NSURL(string: URL)!).onSuccess {
                JSON in
                self.json = SwiftyJSON.JSON(data: JSON.asData())
//                dispatch_semaphore_signal(semaphore)
                flag = true
            }
        
//            Alamofire.request(.GET, URL, headers: ["Content-Type": "application/json"]).responseJSON {
//                response in
////                if (response.response != nil) {
////                    let cachedURLResponse = NSCachedURLResponse(response: response.response!, data: response.data!)
////                    NSURLCache.sharedURLCache().storeCachedResponse(cachedURLResponse, forRequest: response.request!)
//                    NSLog("Success: \(response.request?.URL)")
//                    self.json = JSON(data: response.data!)
////                    dispatch_semaphore_signal(semaphore)
//                    flag = true
////                } else {
////                    self.json = JSON("")
//////                    dispatch_semaphore_signal(semaphore)
////                    flag = true
////                }
//            }
//        }
        while (!flag) {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return self.json
    }
    
    func PostJSON(URL: String, parameters: Dictionary<String, AnyObject>) -> SwiftyJSON.JSON {
        Alamofire.request(.POST, URL, parameters: parameters, encoding: .JSON).responseJSON {
            response in
            NSLog("Success: \(response.request?.URL)")
            self.json = JSON(data: response.data!)
            print(self.json)
        }
        return json
    }
    
    // pass
    func GetHotTopic() -> Array<CC98Topic> {
        let topicsJSON = GetJSON(baseURL + "Topic/Hot")
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
        let topicsJSON = GetJSON(baseURL + "Topic/Board/\(boardID)?from=\(from)&to=\(to)")
        var topics = Array<CC98Topic>()
        if topicsJSON.count > 0 {
            for i in 0...topicsJSON.count-1 {
                topics.append(CC98Topic(data: topicsJSON[i]))
            }
        }
        return topics
    }
    
    // pass
    func GetTopicInfo(topicID: Int) -> SwiftyJSON.JSON {
        return GetJSON(baseURL + "Topic/\(topicID)")
    }
    
    // pass
    func GetTopicPost(topicID: Int, from: Int, to: Int) -> Array<CC98Post> {
        let postsJSON = GetJSON(baseURL + "Post/Topic/\(topicID)?from=\(from)&to=\(to)")
        var posts = Array<CC98Post>()
        if postsJSON.count > 0 {
            for i in 0...postsJSON.count-1 {
                posts.append(CC98Post(postInfo: postsJSON[i]))
            }
        }
        return posts
    }
    
    // pass
    func GetPost(postID: Int) -> CC98Post {
        return CC98Post(postInfo: GetJSON(baseURL + "Post/\(postID)"))
    }
    // User
    // pass
    func GetUserByName(userName: String) -> SwiftyJSON.JSON {
        return GetJSON(baseURL + "User/Name/\(userName)")
    }
    
    // pass
    func GetUserByID(userID: Int) -> SwiftyJSON.JSON {
        return GetJSON(baseURL + "User/\(userID)")
    }
    
    
    // Board
    // pass
    func GetRootBoard() -> Array<CC98Board> {
        let boardsJSON = GetJSON(baseURL + "Board/Root")
        var boards = Array<CC98Board>()
        if boardsJSON.count > 0 {
            for i in 0...boardsJSON.count-1 {
                boards.append(CC98Board(data: boardsJSON[i]))
            }
        }
        return boards
    }
    // pass
    func GetSubBoards(boardID: Int) -> SwiftyJSON.JSON {
        return GetJSON(baseURL + "Board/\(boardID)/Subs")
    }
    // pass
    func GetBoardInfo(boardID: Int) -> SwiftyJSON.JSON {
        return GetJSON(baseURL + "Board/\(boardID)")
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
//        content = content.stringByReplacingOccurrencesOfString("quote]", withString: "quotex]")
        if networkStatus == "Cellular" {
            content = content.stringByReplacingOccurrencesOfString("http://file.cc98.org", withString: "https://rvpn.zju.edu.cn/web/1/http/0/file.cc98.org")
            avatar = avatar.stringByReplacingOccurrencesOfString("http://file.cc98.org", withString: "https://rvpn.zju.edu.cn/web/1/http/0/file.cc98.org")
            avatar = avatar.stringByReplacingOccurrencesOfString("http://www.cc98.org", withString: "https://rvpn.zju.edu.cn/web/1/http/0/www.cc98.org")
            signature = signature.stringByReplacingOccurrencesOfString("http://file.cc98.org", withString: "https://rvpn.zju.edu.cn/web/1/http/0/file.cc98.org")
            signature = signature.stringByReplacingOccurrencesOfString("http://www.cc98.org", withString: "https://rvpn.zju.edu.cn/web/1/http/0/www.cc98.org")
            print(avatar)
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
//        print(finalText)
        return finalText as String
    }
    
    func GetImageUrls(content: String) -> Array<String> {
        var result = Array<String>()
        do {
            
            var begin = 0
            let pattern1 = "https?://(?:[a-z0-9\\-]+\\.)+[a-z]{2,6}(?:/[^/#?]+)+\\.(?:jpg|gif|png|jpeg|bmp)"
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
                print(res1)
                if (res1.length == 0) {
                    break
                }
            }
        }
        catch {
            print(error)
        }
        return Array(Set(result))
    }
}