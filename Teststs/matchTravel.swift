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
    var matchStart: matchStart?
    var matchWorld: matchWorld?
    let viewNumber = 4
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViewFromData()
        
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
        
        print(matchData.currentview)
        if viewNumber < matchData.currentview {
            goRightWithoutAnimation()
        }
        
        
        let emojiFontSize = CGFloat(30.0)
        let title1 = NSMutableAttributedString(
            string: emojiStruct.emojiDict[0],
            attributes: [NSFontAttributeName:UIFont(
                name: (button1.titleLabel?.font.fontName)!,
                size: emojiFontSize)!])
        let title2 = NSMutableAttributedString(
            string: emojiStruct.emojiDict[1],
            attributes: [NSFontAttributeName:UIFont(
                name: (button2.titleLabel?.font.fontName)!,
                size: emojiFontSize)!])
        let title3 = NSMutableAttributedString(
            string: emojiStruct.emojiDict[2],
            attributes: [NSFontAttributeName:UIFont(
                name: (button3.titleLabel?.font.fontName)!,
                size: emojiFontSize)!])
        let title4 = NSMutableAttributedString(
            string: emojiStruct.emojiDict[3],
            attributes: [NSFontAttributeName:UIFont(
                name: (button4.titleLabel?.font.fontName)!,
                size: emojiFontSize)!])
        let title5 = NSMutableAttributedString(
            string: emojiStruct.emojiDict[4],
            attributes: [NSFontAttributeName:UIFont(
                name: (button5.titleLabel?.font.fontName)!,
                size: emojiFontSize)!])
        
        button1.setAttributedTitle(title1, for: UIControlState.normal)
        button2.setAttributedTitle(title2, for: UIControlState.normal)
        button3.setAttributedTitle(title3, for: UIControlState.normal)
        button4.setAttributedTitle(title4, for: UIControlState.normal)
        button5.setAttributedTitle(title5, for: UIControlState.normal)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func buildViewFromData(){
        let something = self.matchData.backendData["questions"]
        for val in something! {
            print(val)
        }
    }
    
    func goRightWithoutAnimation(){
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchTeam") as! matchTeam
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchTravel = self
        self.navigationController?.pushViewController(rightViewController, animated: false)
    }
    
    func goRight(){
        matchData.currentview += 1
        matchData.save()
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchTeam") as! matchTeam
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchTravel = self
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
        matchData.currentview -= 1
        matchData.save()
        // send data back to previous view-controller
        self.matchWorld?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
