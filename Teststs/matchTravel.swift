//
//  matchTravel.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-05.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchTravel: UIViewController {
    
    var matchData: matchDataClass = matchDataClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        // do stuff
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recieveData), name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: nil)
    }
    
    func recieveData(notification: NSNotification){
        let data = notification.object as! matchDataClass
        self.matchData = data
        print("matchData.currentview is \(matchData.currentview)")
    }
    
    func goRight(){
        print("going to matchTeam")
        matchData.currentview += 1
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchTeam") as! matchTeam
        rightViewController.matchData = self.matchData
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
        print("going back to matchEurope")
        matchData.currentview -= 1
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: matchData)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
