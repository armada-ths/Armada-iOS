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
    @IBOutlet weak var interestLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recieveData), name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: nil)
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
        // decide if to go to another matchInterest or go next class
        if matchData.interestList.count != (matchData.currentInterest + 1) {
            // increment currentInterest
            matchData.currentInterest += 1
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest
            rightViewController.matchData = self.matchData
            self.navigationController?.pushViewController(rightViewController, animated: true)
        } else {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEnd") as! matchEnd
            rightViewController.matchData = self.matchData
            self.navigationController?.pushViewController(rightViewController, animated: true)
        }
    }
    
    func goBack(){
        print("going back")
        matchData.teamSize = matchData.teamSize + 1
        matchData.currentview -= 1
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: matchData)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
