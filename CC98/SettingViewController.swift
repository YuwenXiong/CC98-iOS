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
    }
}