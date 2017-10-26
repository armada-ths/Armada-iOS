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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    @IBAction func pushButton1(_ sender: Any) {
        if (!button1.isSelected) {
            button1.isSelected = true
            button2.isSelected = false
            button3.isSelected = false
            button4.isSelected = false
            button5.isSelected = false
            updateButtons()
        }
    }
    @IBAction func pushButton2(_ sender: Any) {
        if (!button2.isSelected) {
            button1.isSelected = false
            button2.isSelected = true
            button3.isSelected = false
            button4.isSelected = false
            button5.isSelected = false
            updateButtons()
        }
    }
    @IBAction func pushButton3(_ sender: Any) {
        if (!button3.isSelected) {
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = true
            button4.isSelected = false
            button5.isSelected = false
            updateButtons()
        }
    }
    @IBAction func pushButton4(_ sender: Any) {
        if (!button4.isSelected) {
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = false
            button4.isSelected = true
            button5.isSelected = false
            updateButtons()
        }
    }
    @IBAction func pushButton5(_ sender: Any) {
        if (!button5.isSelected) {
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = false
            button4.isSelected = false
            button5.isSelected = true
            updateButtons()
        }
    }
    
    func pushSmiley(_ pushedButton: UIButton){
        if pushedButton.isSelected == true {
            pushedButton.alpha = 0.4
            pushedButton.isSelected = false
        } else if pushedButton.isSelected == false{
            pushedButton.alpha = 1
            pushedButton.isSelected = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //buildViewFromData()        
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
        
        print(matchData.currentview)
        if viewNumber < matchData.currentview {
            goRightWithoutAnimation()
        }
        
        
        let emojiFontSize = CGFloat(40.0)
        let title1normal = NSMutableAttributedString(
            string: emojiStruct.emojiDict[0],
            attributes: [NSFontAttributeName:UIFont(
                name: (button1.titleLabel?.font.fontName)!,
                size: emojiFontSize)!])
        let title2normal = NSMutableAttributedString(
            string: emojiStruct.emojiDict[1],
            attributes: [NSFontAttributeName:UIFont(
                name: (button2.titleLabel?.font.fontName)!,
                size: emojiFontSize)!])
        let title3normal = NSMutableAttributedString(
            string: emojiStruct.emojiDict[2],
            attributes: [NSFontAttributeName:UIFont(
                name: (button3.titleLabel?.font.fontName)!,
                size: emojiFontSize)!])
        let title4normal = NSMutableAttributedString(
            string: emojiStruct.emojiDict[3],
            attributes: [NSFontAttributeName:UIFont(
                name: (button4.titleLabel?.font.fontName)!,
                size: emojiFontSize)!])
        let title5normal = NSMutableAttributedString(
            string: emojiStruct.emojiDict[4],
            attributes: [NSFontAttributeName:UIFont(
                name: (button5.titleLabel?.font.fontName)!,
                size: emojiFontSize)!])
        
        let title1selected = NSMutableAttributedString(
            string: emojiStruct.emojiDict[0],
            attributes: [NSFontAttributeName:UIFont(
                name: (button1.titleLabel?.font.fontName)!,
                size: emojiFontSize + 10)!])
        let title2selected = NSMutableAttributedString(
            string: emojiStruct.emojiDict[1],
            attributes: [NSFontAttributeName:UIFont(
                name: (button2.titleLabel?.font.fontName)!,
                size: emojiFontSize + 10)!])
        let title3selected = NSMutableAttributedString(
            string: emojiStruct.emojiDict[2],
            attributes: [NSFontAttributeName:UIFont(
                name: (button3.titleLabel?.font.fontName)!,
                size: emojiFontSize + 10)!])
        let title4selected = NSMutableAttributedString(
            string: emojiStruct.emojiDict[3],
            attributes: [NSFontAttributeName:UIFont(
                name: (button4.titleLabel?.font.fontName)!,
                size: emojiFontSize + 10)!])
        let title5selected = NSMutableAttributedString(
            string: emojiStruct.emojiDict[4],
            attributes: [NSFontAttributeName:UIFont(
                name: (button5.titleLabel?.font.fontName)!,
                size: emojiFontSize + 10)!])
        
        button1.setAttributedTitle(title1normal, for: UIControlState.normal)
        button1.setAttributedTitle(title1selected, for: UIControlState.selected)
        button2.setAttributedTitle(title2normal, for: UIControlState.normal)
        button2.setAttributedTitle(title2selected, for: UIControlState.selected)
        button3.setAttributedTitle(title3normal, for: UIControlState.normal)
        button3.setAttributedTitle(title3selected, for: UIControlState.selected)
        button4.setAttributedTitle(title4normal, for: UIControlState.normal)
        button4.setAttributedTitle(title4selected, for: UIControlState.selected)
        button5.setAttributedTitle(title5normal, for: UIControlState.normal)
        button5.setAttributedTitle(title5selected, for: UIControlState.selected)
        
        updateButtons()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func updateButtons(){
        if button1.isSelected {
            button1.alpha = 1
        }
        if !button1.isSelected {
            button1.alpha = 0.4
        }
        if button2.isSelected {
            button2.alpha = 1
        }
        if !button2.isSelected {
            button2.alpha = 0.4
        }
        if button3.isSelected {
            button3.alpha = 1
        }
        if !button3.isSelected {
            button3.alpha = 0.4
        }
        if button4.isSelected {
            button4.alpha = 1
        }
        if !button4.isSelected {
            button4.alpha = 0.4
        }
        if button5.isSelected {
            button5.alpha = 1
        }
        if !button5.isSelected {
            button5.alpha = 0.4
        }
    }
    
    func buildViewFromData(){
//        let something = self.matchData.backendData["questions"]
//        let sliderData = something![0]
//        let titleAttributedText = NSMutableAttributedString(
//            string: sliderData["question"] as! String,
//            attributes: [NSFontAttributeName:UIFont(
//                name: "BebasNeueRegular",
//                size: 35)!])
//        titleLabel.attributedText = titleAttributedText
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
