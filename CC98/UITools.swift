//
//  UITools.swift
//  CC98
//
//  Created by CCNT on 12/16/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import UIKit


class UITools: NSObject {

    class func GetViewController<T>(controllerName:String)->T {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let toViewController = mainStoryboard.instantiateViewControllerWithIdentifier(controllerName) as! T
        return toViewController
        
    }

}