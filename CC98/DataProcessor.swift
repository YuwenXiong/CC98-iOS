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

class DataProcessor {
    var json: JSON = nil
    func GetJSON(URL: String) -> JSON {
        var flag = false
        Alamofire.request(.GET, URL, headers: ["Content-Type": "application/json"]).responseJSON {
            response in
            NSLog("Success: \(response.request?.URL)")
            self.json = JSON(data: response.data!)
//            print(self.json)
            flag = true
        }
        while (!flag) {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
        return self.json
    }
    
    func PostJSON(URL: String, parameters: Dictionary<String, AnyObject>) -> JSON {
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
                topics.append(CC98Topic(ID: topicsJSON[i]["id"].intValue))
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
                topics.append(CC98Topic(ID: topicsJSON[i]["id"].intValue))
            }
        }
        return topics
    }
    
    // pass
    func GetTopicInfo(topicID: Int) -> JSON {
        return GetJSON(baseURL + "Topic/\(topicID)")
    }
    
    // pass
    func GetTopicPost(topicID: Int, from: Int, to: Int) -> Array<CC98Post> {
        let postsJSON = GetJSON(baseURL + "Post/Topic/\(topicID)?from=\(from)&to=\(to)")
        var posts = Array<CC98Post>()
        if postsJSON.count > 0 {
            for i in 0...postsJSON.count-1 {
                posts.append(CC98Post(postInfo: postsJSON[i], dataProcessor: self))
            }
        }
        return posts
    }
    
    // pass
    func GetPost(postID: Int) -> CC98Post {
        return CC98Post(postInfo: GetJSON(baseURL + "Post/\(postID)"), dataProcessor: self)
    }
    // User
    // pass
    func GetUserByName(userName: String) -> JSON {
        return GetJSON(baseURL + "User/Name/\(userName)")
    }
    
    // pass
    func GetUserByID(userID: Int) -> JSON {
        return GetJSON(baseURL + "User/\(userID)")
    }
    
    
    // Board
    // pass
    func GetRootBoard() -> Array<CC98Board> {
        let boardsJSON = GetJSON(baseURL + "Board/Root")
        var boards = Array<CC98Board>()
        if boardsJSON.count > 0 {
            for i in 0...boardsJSON.count-1 {
                boards.append(CC98Board(ID: boardsJSON[i]["id"].intValue))
            }
        }
        return boards
    }
    // pass
    func GetSubBoards(boardID: Int) -> JSON {
        return GetJSON(baseURL + "Board/\(boardID)/Subs")
    }
    // pass
    func GetBoardInfo(boardID: Int) -> JSON {
        return GetJSON(baseURL + "Board/\(boardID)")
    }
    
    func GetBoard(boardID: Int) -> CC98Board {
        return CC98Board(ID: boardID)
    }
    
    func ParsePostContent(post: CC98Post) -> String {
        // todo: support rich text
//        let regrex = try! NSRegularExpression(pattern: "\\[[^\\]]+\\]", options: NSRegularExpressionOptions.CaseInsensitive)
//        let ret = regrex.stringByReplacingMatchesInString(content, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, content.characters.count), withTemplate: "")
//        return ret
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
        htmlText.replaceOccurrencesOfString("${avatar}", withString: post.author.avatar, options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(0, htmlText.length))
        htmlText.replaceOccurrencesOfString("${content}", withString: "<div id=\"ubbcode1\">" + post.content + "</div><script>searchubb('ubbcode1',1,'tablebody1');</script>", options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(0, htmlText.length))
        htmlText.replaceOccurrencesOfString("${i}", withString: post.floor, options: NSStringCompareOptions(rawValue: 0), range: NSMakeRange(0, htmlText.length))
        finalText.appendString(htmlText as String)
        finalText.appendString(endPart)
//        print(finalText)
        return finalText as String
    }
}