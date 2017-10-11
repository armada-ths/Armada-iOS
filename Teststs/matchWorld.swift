//
//  matchWorld.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-05.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchWorld: UIViewController {
    
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchSweden: matchSweden?
    
    override func viewWillAppear(_ animated: Bool) {
        print(matchData.currentview)
    }
    
    @IBAction func reset(_ sender: Any) {
        print("reseting data")
        self.matchStart?.matchData = matchDataClass()
        self.navigationController?.popToRootViewController(animated: true
        )
    }
    
    
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
        
        self.matchData.worldBool["europe"]      = false
        self.matchData.worldBool["asia"]        = false
        self.matchData.worldBool["americaN"]    = false
        self.matchData.worldBool["americaS"]    = false
        self.matchData.worldBool["australia"]   = false
    }
    
    
    func goRight(){
        print("going to matchEurope")
        matchData.currentview += 1
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEurope") as! matchEurope
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchWorld = self
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
        print("going back to matchSweden")
        matchData.currentview -= 1
        self.matchSweden?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
