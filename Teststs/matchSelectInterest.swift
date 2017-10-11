//
//  matchSelectInterest.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-04.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchSelectInterest: UIViewController {
    
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchTeam: matchTeam?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        // do stuff with matchSelectInterest
        
        self.matchData.interestBools["it"]              = false
        self.matchData.interestBools["chemistry"]       = true
        self.matchData.interestBools["finance"]         = false
        self.matchData.interestBools["infrastructure"]  = true
        self.matchData.interestBools["management"]      = true
        self.matchData.interestBools["innovation"]      = false
        
    }
    
    func goRight(){
        print("going forward")
        matchData.currentview += 1
        // reset interestList to empty array
        matchData.interestList = []
        for (key, value) in matchData.interestBools {
            if value == true{
                matchData.interestList.append(key)
            }
        }
        if matchData.interestList.count == 0 {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchEnd
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchSelectInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: true)
        } else {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchSelectInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: true)
        }
    }
    
    func goBack(){
        print("going back")
        matchData.currentview -= 1
        // send data back to previous view-controller
        self.matchTeam?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
