//
//  configure.swift
//  CC98
//
//  Created by Orpine on 11/26/15.
//  Copyright © 2015 Orpine. All rights reserved.
//

import Foundation
import ReachabilitySwift
import p2_OAuth2
var baseURL = "http://api.cc98.org/"
let siteURL = "http://www.cc98.org/"

let globalDataProcessor = DataProcessor()
//let globalReachabilityCheck = Reach()



let settings = [
    "client_id": "a9f98862-05ad-417f-814b-81c05804a047",
    "client_secret": "84e21510-02f4-4992-b6ee-823a3f64e33d",
    "authorize_uri": "https://login.cc98.org/OAuth/Authorize",
    "token_uri": "https://login.cc98.org/OAuth/Token",
    "scope": "all",
    "redirect_uris": ["cc98://oauth/callback"],     // don't forget to register this scheme
    "keychain": true,                              // if you DON'T want keychain integration
    "title": "CC98 OAuth Login"                     // optional title to show in views
    ] as OAuth2JSON                                 // the "as" part may or may not be needed

let oauth = OAuth2CodeGrant(settings: settings)