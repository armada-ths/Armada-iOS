//
//  matchInterest.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-04.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchInterest: UIViewController {
    
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchInterest: matchInterest?
    var matchSelectInterest: matchSelectInterest?
    
    @IBOutlet weak var interestLabel: UILabel!
    
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
        
        // get the key attribute
        print(matchData.interestList)
        print(matchData.currentInterest)
        let attribute:String = matchData.interestList[matchData.currentInterest]
        interestLabel.text = attribute        
    }
    
    func recieveData(notification: NSNotification){
        print("recieved data from right view")
        print("matchData.currentview is \(matchData.currentview)")
        let data = notification.object as! matchDataClass
        self.matchData = data
    }
    
    func goRight(){
        print("going forward")
        matchData.currentview += 1
        if matchData.interestList.count != (matchData.currentInterest + 1) {
            matchData.currentInterest += 1
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: true)
        } else {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEnd") as! matchEnd
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: true)
        }
    }
    
    func goBack(){
        print("going back")
        matchData.currentview -= 1
        if self.matchData.currentInterest == 0 {
            self.matchSelectInterest?.matchData = matchData
        } else {
            matchData.currentInterest -= 1
            self.matchInterest?.matchData = matchData
        }        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
