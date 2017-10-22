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
    var matchStart: matchStart?
    var matchLooking: matchLooking?
    let viewNumber = 2

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBar()
        swipe()
        
        button1.backgroundColor = .white
        button1.layer.cornerRadius = 5
        button1.layer.borderWidth = 0.75
        button1.layer.borderColor = UIColor.darkGray.cgColor
        button1.layer.shadowOpacity = 0.12
        button1.layer.shadowOffset = CGSize(width: -1, height: 3)
        
        print(matchData.currentview)
        if viewNumber < matchData.currentview {
            goRightWithoutAnimation()
        }
        let titleText = NSMutableAttributedString(
            string: "There are more than 200 exhibitors at \nArmada Fair 21-22 November, \nwe will help you find the five best for you!",
            attributes: [NSFontAttributeName:UIFont(
                name: "Lato-Light",
                size: 18.0)!])
    }
    
    func statusBar(){
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
    }
    
    func swipe(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func goRightWithoutAnimation(){
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchWorld") as! matchWorld
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = self.matchStart
        rightViewController.matchSweden = self
        self.navigationController?.pushViewController(rightViewController, animated: false)
    }
    
    func goRight(){
        matchData.currentview += 1
        matchData.save()
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchWorld") as! matchWorld
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = self.matchStart
        rightViewController.matchSweden = self
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
        matchData.currentview -= 1
        matchData.save()
        self.matchLooking?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
