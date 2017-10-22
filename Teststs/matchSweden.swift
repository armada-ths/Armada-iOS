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
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBar()
        swipe()
        
        let buttonArray = [button1, button2, button3, button4, button5, button6, button7, button8]
        let buttonNameArray = ["North norrland", "South norrland", "Svealand", "Stockholm", "Region West", "Region East", "Göteborg", "Region South", "Malmö"]
        
        let title = NSMutableAttributedString(
            string: "WHERE IN SWEDEN DO YOU WANT TO WORK?\n SELECT THE REGIONS",
            attributes: [NSFontAttributeName:UIFont(
                name: "Lato-Light",
                size: 16)!, NSForegroundColorAttributeName: UIColor.black])
        titleLabel.attributedText = title
        for idx in 0...(buttonArray.count - 1) {
            let tmpButton = buttonArray[idx] as! UIButton
            let title = NSMutableAttributedString(
                string: buttonNameArray[idx],
                attributes: [NSFontAttributeName:UIFont(
                    name: "Lato-Light",
                    size: 20)!, NSForegroundColorAttributeName: UIColor.black])
            tmpButton.setAttributedTitle(title, for: UIControlState.normal)
            tmpButton.setAttributedTitle(title, for: UIControlState.selected)
            tmpButton.backgroundColor = .white
            tmpButton.layer.cornerRadius = 5
            tmpButton.layer.borderWidth = 0.75
            tmpButton.layer.borderColor = UIColor.darkGray.cgColor
            tmpButton.layer.shadowOpacity = 0.12
            tmpButton.layer.shadowOffset = CGSize(width: -1, height: 3)
            tmpButton.titleColor(for: UIControlState.normal)
        }
        
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
