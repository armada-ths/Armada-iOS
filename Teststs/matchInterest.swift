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
    let viewNumber = 7
    
    @IBOutlet weak var interestLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
        
        print(matchData.currentview)
        print("matchData.currentInterest: \(matchData.currentInterest)")
        
        if (viewNumber + matchData.currentInterest < matchData.currentview) {
            goRightWithoutAnimation()
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        let attribute:String = matchData.interestList[matchData.currentInterest]
        interestLabel.text = attribute        
    }
    
    func goRightWithoutAnimation(){
        if matchData.interestList.count != (matchData.currentInterest + 1) {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: false)
        } else {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEnd") as! matchEnd
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: false)
        }
    }
    
    func goRight(){
        matchData.currentview += 1        
        if matchData.interestList.count != (matchData.currentInterest + 1) {
            matchData.currentInterest += 1
            matchData.save()
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: true)
        } else {
            matchData.save()
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEnd") as! matchEnd
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: true)
        }
    }
    
    func goBack(){
        matchData.currentview -= 1
        if self.matchData.currentInterest == 0 {
            self.matchSelectInterest?.matchData = matchData
            matchData.save()
        } else {
            matchData.currentInterest -= 1
            matchData.save()
            self.matchInterest?.matchData = matchData
        }        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
