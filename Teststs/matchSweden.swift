//
//  matchSweden.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-05.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchSweden: UIViewController {
    
    var matchData: matchDataClass = matchDataClass()
    
    override func viewWillAppear(_ animated: Bool) {
        let blockview = UIView(frame: CGRect(x:0, y:0, width: 100, height:(self.navigationController?.navigationBar.frame.height)! - 2))
        blockview.backgroundColor = ColorScheme.leilaDesignGrey
        blockview.tag = 666
        self.navigationController?.navigationBar.addSubview(blockview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = ColorScheme.leilaDesignGrey
        
        let blockview = UIView(frame: CGRect(x:0, y:0, width: 100, height:(self.navigationController?.navigationBar.frame.height)! - 2))
        blockview.backgroundColor = ColorScheme.leilaDesignGrey
        blockview.tag = 666
        self.navigationController?.navigationBar.addSubview(blockview)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        // do stuff with matchLooking
        
        /*
         swedenBool = [
         "area1": false,
         "area2": false,
         "area3": false
         ]
         */
        
        self.matchData.swedenBool["area1"]     = false
        self.matchData.swedenBool["area2"]     = false
        self.matchData.swedenBool["area3"]     = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recieveData), name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: nil)
    }
    
    func recieveData(notification: NSNotification){
        let data = notification.object as! matchDataClass
        self.matchData = data
        print("matchData.currentview is \(matchData.currentview)")
    }
    
    func goRight(){
        print("going to matchWorld")
        matchData.currentview += 1
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchWorld") as! matchWorld
        rightViewController.matchData = self.matchData
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
        print("going back to matchLooking")
        matchData.currentview -= 1
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: matchData)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.viewWithTag(666)?.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
