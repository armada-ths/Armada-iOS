//
//  NewsNavBar.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-20.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class NewsNavController: UINavigationController {
    
    override func viewDidLoad() {
        let designGrey = UIColor(red: 0xF8/255, green: 0xF7/255, blue: 0xF7/255, alpha: 1)
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = designGrey
    }    
}
