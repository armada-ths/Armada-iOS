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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        // do stuff with matchSelectInterest
        
        /*
         interestBools = [
         "it":               false,
         "chemistry":        false,
         "finance":          false,
         "infrastructure":   false,
         "management":       false,
         "innovation":       false
         ]
         */
        
        self.matchData.interestBools["it"]              = false
        self.matchData.interestBools["chemistry"]       = true
        self.matchData.interestBools["finance"]         = false
        self.matchData.interestBools["infrastructure"]  = true
        self.matchData.interestBools["management"]      = true
        self.matchData.interestBools["innovation"]      = false
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recieveData), name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: nil)
    }
    
    func recieveData(notification: NSNotification){
        print("in matchSelectInterest view")
        let data = notification.object as! matchDataClass
        self.matchData = data
        print("recieved data from first match interest view")
        matchData.currentInterest = 0
        print("matchData.currentview is \(matchData.currentview)")
    }
    
    func goRight(){
        print("going forward")
        // reset interestList to empty array
        matchData.interestList = []
        for (key, value) in matchData.interestBools {
            if value == true{
                matchData.interestList.append(key)
            }
        }
        if matchData.interestList.count == 0 {
            // jump to view after matchInterest
        } else {
            // jump into first matchInterest
            matchData.currentview += 1
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest
            rightViewController.matchData = self.matchData
            self.navigationController?.pushViewController(rightViewController, animated: true)
        }
    }
    
    func goBack(){
        print("going back")
        matchData.currentview -= 1
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: matchData)
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
