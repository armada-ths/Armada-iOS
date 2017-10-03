//
//  NewsNavigationController.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-22.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class NewsNavigationController: UINavigationController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // constants
        let extraH:CGFloat = 0
        let headerW = self.navigationBar.bounds.width
        var headerH = self.navigationBar.bounds.height + extraH
        let statusH:CGFloat = 20
        let logoOffset:CGFloat = 10
        
        // set navigationBar size
        self.navigationBar.frame = CGRect(x:0, y:0, width:headerW, height: statusH + headerH)
        
        // make navigationbar solid
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = ColorScheme.leilaDesignGrey
        
        // remove navigationbar-border
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:headerW, height: statusH))
        statusView.backgroundColor = .black
        statusView.tag = 0
        self.navigationBar.addSubview(statusView)
        
        // Don't load this more than once
        if self.navigationBar.viewWithTag(1) == nil {
            
            // setup left logo
            let logoimg = #imageLiteral(resourceName: "armada_round_logo_green.png")
            //let logoimg = #imageLiteral(resourceName: "THSarmada_logo.png")
            let logorawW = logoimg.size.width
            let logorawH = logoimg.size.height
            let logoratioWH:CGFloat = logorawW/logorawH
            let logoH = headerH * 0.8
            let logoW = logoH * logoratioWH
            let logoframe = CGRect(x: logoOffset, y: self.yoffset(statusH, headerH, logoH), width: logoW, height: logoH)
            let logoImageView = UIImageView(frame: logoframe)
            logoImageView.image = logoimg
            logoImageView.tag = 1
            self.navigationBar.addSubview(logoImageView)
            //self.navigationItem.titleView = newTitleView
            
            // setup header bottom border
            let headerHeight:CGFloat = self.navigationBar.frame.size.height
            let bottomBorderH:CGFloat = 0.75
            let bottomBorderRect = CGRect(x: 0, y: headerHeight, width: UIScreen.main.bounds.width, height: bottomBorderH)
            let bottomBorderView = UIView(frame: bottomBorderRect)
            bottomBorderView.backgroundColor = ColorScheme.navbarBorderGrey
            self.navigationBar.addSubview(bottomBorderView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view.
    }
    
    func yoffset(_ statusH: CGFloat, _ headerH: CGFloat, _ itemH: CGFloat ) -> CGFloat {
        return (statusH + headerH / 2.0 - itemH / 2.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
