//
//  MatchNavigationController.swift
//  Armada
//
//  Created by Ola Roos on 2017-10-10.
//  Copyright © 2017 Sami Purmonen. All rights reserved.
//

import UIKit

class MatchNavigationController: UINavigationController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //if let blockView = self.navigationController?.navigationBar.viewWithTag(<#T##tag: Int##Int#>)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.backgroundColor = ColorScheme.leilaDesignGrey
        
        // constants
        let extraH:CGFloat = 0
        let headerW:CGFloat = self.navigationBar.bounds.width
        var headerH:CGFloat = 0.0
        let statusH:CGFloat = 20
        let logoOffset:CGFloat = 10
        
        // set navigationBar size
        self.navigationBar.frame = CGRect(x:0, y:0, width:headerW, height: headerH)
        
        // make navigationbar solid
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = .black
        
        // remove navigationbar-border
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:-statusH, width:headerW, height: statusH))
        statusView.backgroundColor = .black
        statusView.tag = 0
        self.navigationBar.addSubview(statusView)
        /*
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
        */
    }
    
    func yoffset(_ statusH: CGFloat, _ headerH: CGFloat, _ itemH: CGFloat ) -> CGFloat {
        return (headerH / 2.0 - itemH / 2.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}