//
//  SettingsManager.swift
//  Teststs
//
//  Created by Sami Purmonen on 23/09/15.
//  Copyright © 2015 Sami Purmonen. All rights reserved.
//

import UIKit


let SettingsManager = _SettingsManager()

class _SettingsManager {
    
    let Ω = NSUserDefaults.standardUserDefaults()
    
    
    var companiesEtag: String? {
        get { return Ω["companiesEtag"] as? String /*?? "72f197da9005d9d3b0353e8f1c00c7e8"*/ }
        set { Ω["companiesEtag"] = newValue }
    }
}