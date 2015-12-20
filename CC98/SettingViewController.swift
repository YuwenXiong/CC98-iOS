//
//  SettingViewController.swift
//  CC98
//
//  Created by Orpine on 12/18/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var VPN_Username: UITextField!
    @IBOutlet weak var VPN_Password: UITextField!
    @IBOutlet weak var VPN_Switch: UISwitch!
    @IBAction func VPN_UsernameEdited(sender: AnyObject) {
        userDefaults.setValue(VPN_Username.text, forKey: "VPN_Username")
    }
    @IBAction func VPN_PasswordEdited(sender: AnyObject) {
        userDefaults.setValue(VPN_Password.text, forKey: "VPN_Password")
    }
    
    @IBAction func VPN_SwitchChanged(sender: AnyObject) {
        userDefaults.setValue(VPN_Switch.on, forKey: "VPN_Switch")
        if VPN_Switch.on {
            container.hidden=false
        }
        else{
            container.hidden=true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if VPN_Switch.on {
            container.hidden=false
        }
        else{
            container.hidden=true
        }
        if let username = userDefaults.valueForKey("VPN_Username") as? String {
            VPN_Username.text = username
        }
        if let password = userDefaults.valueForKey("VPN_Password") as? String {
            VPN_Password.text = password
        }
   }
}