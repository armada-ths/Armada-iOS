//
//  ViewController.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-22.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class AboutNavController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationBar.isTranslucent = true
    }
    override func viewDidLoad() {
        //let designGrey = UIColor(red: 0xF8/255, green: 0xF7/255, blue: 0xF7/255, alpha: 1)
        
        //self.navigationBar.barTintColor = designGrey
    }
}

