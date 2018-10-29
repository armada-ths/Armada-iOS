//
//  NavBarController.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-20.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class NavBarController: UINavigationController {

    override func viewDidLoad() {
        let designGrey = UIColor(red: 0xF8/255, green: 0xF7/255, blue: 0xF7/255, alpha: 1)
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = designGrey
    }
    /*
    //override var isTranslucent: Bool {
        didSet {
            if self.isTranslucent {
                self.isTranslucent = false
            }
        }
    }
     */
    //override var isTranslucent: Bool {get {return false}}
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     
    //override func draw(_ rect: CGRect) {
        // Drawing code
    //}
    

}
