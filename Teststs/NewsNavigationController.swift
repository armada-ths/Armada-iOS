//
//  NewsNavigationController.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-22.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class NewsNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let designGrey = UIColor(red: 0xF8/255, green: 0xF7/255, blue: 0xF7/255, alpha: 1)
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = designGrey
        
        // setup header bottom border
        let headerHeight:CGFloat = self.navigationBar.frame.size.height
        let bottomBorderH:CGFloat = 0.75
        let bottomBorderRect = CGRect(x: 0, y: headerHeight, width: UIScreen.main.bounds.width, height: bottomBorderH)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = ColorScheme.navbarBorderGrey
        self.navigationBar.addSubview(bottomBorderView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}