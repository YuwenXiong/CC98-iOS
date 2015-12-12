//
//  AppDelegate.swift
//  CC98
//
//  Created by Orpine on 11/13/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import UIKit
//import p2_OAuth2

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        let X = DataProcessor()
        let temp = globalDataProcessor.GetHotTopic()
//        X.GetHotTopic()
//        X.GetBoardTopic(744, from: 0, to: 19)
//        X.GetTopicInfo(4582400)
//        let posts = X.GetTopicPost(4582400, from: 0, to: 19)
//        X.ParsePostContent(posts[0]["content"].string!)
//        let boards = X.GetRootBoard()
//        let posts = X.GetTopicPost(4582400, from: 0, to: 19)
        
//        X.ParsePostContent(posts[0].content)
//        X.GetPost(791058817)
//        X.GetUserByName("Orpine")
//        X.GetUserByID(524166)
//        X.GetBoardRoot()
//        X.GetSubBoards(2)
//        X.GetBoardInfo(744)

        return true
    }
    


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

