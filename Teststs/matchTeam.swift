//
//  matchTeam.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-05.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit
import SwiftRangeSlider
class matchTeam: UIViewController {
    
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchTravel: matchTravel?
    let viewNumber = 5
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var dotsimage: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        if self.view.viewWithTag(666) == nil {
            addSlider()
        }
    }
    
    func setupSwipe(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func setupStatusBar(){
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
    }
    func goBackWithoutAnimation(){
        matchData.save()
        // send data back to previous view-controller
        self.matchTravel?.matchData = matchData
        self.navigationController?.popViewController(animated: false)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if(matchData.currentview < viewNumber){
            goBackWithoutAnimation()
        }
        self.setupSwipe()
        self.setupStatusBar()
        if viewNumber < matchData.currentview {
            goRightWithoutAnimation()
        }
        
        // if there is no matchDataInstructions use hardcoded values instead
        if !self.matchData.slider.isEmpty{
            let attributedTitel = NSMutableAttributedString(
                string: self.matchData.slider["question"] as! String,
                attributes: [NSFontAttributeName:UIFont(
                    name: "BebasNeueRegular",
                    size: 35)!])
            titleLabel.attributedText = attributedTitel
        } else {
            // INSERT HARDCODED VALUES HERE
            print("there is no matchData.slider values")
        }
                
    }
    
    func updateSlider(sliderview: RangeSlider){
        if !self.matchData.sliderValues.isEmpty {
            // REMEMBER THAT YOU HAVE TO REVERSE THESE VALUES!!!! THEY ARE TAKEN FROM
            // reverseValues() function!!!! FFS!
            print("updateSlider")
            if (self.matchData.sliderValues["max"]! < sliderview.maximumValue){
                sliderview.lowerValue = sliderview.maximumValue
            } else {
                sliderview.lowerValue = (self.matchData.sliderValues["max"])!
            }
            if (self.matchData.sliderValues["min"]! > sliderview.minimumValue){
                sliderview.lowerValue = sliderview.minimumValue
            } else {
                sliderview.lowerValue = (self.matchData.sliderValues["min"])!
            }
            print(sliderview.lowerValue)
            print(sliderview.upperValue)
        } else {
            sliderview.upperValue = sliderview.maximumValue
            sliderview.lowerValue = sliderview.minimumValue
        }
    }
    
    func addSlider(){
        // insert custom view with constraints
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let statusheight = CGFloat(20)
        let footerheight = CGFloat(60)
        let constoffsetsum = CGFloat(50)
        let sliderheight = screenheight - headerview.bounds.height - dotsimage.bounds.height - constoffsetsum - statusheight - footerheight
        
        let frame = CGRect(x:(screenwidth - 35)/2,y:(statusheight+headerview.bounds.height+40),width:35,height:sliderheight)
        var sliderview:RangeSlider = RangeSlider(frame: frame)
//        sliderview.labelFontSize = 30
        if !self.matchData.slider.isEmpty {
            print("addSlider")
            print(Double(self.matchData.slider["max"] as! Int))
            print(Double(self.matchData.slider["min"] as! Int))
            sliderview.maximumValue = Double(self.matchData.slider["max"] as! Int)
            sliderview.minimumValue = Double(self.matchData.slider["min"] as! Int)
        } else {
            print("somethings wrong using hardcoded values maximumValue = 100 minimumValue = 0")
            sliderview.maximumValue = 100
            sliderview.minimumValue = 0
            // USER HARDCODED VALUES HERE
        }
        sliderview.knobSize = 2
        sliderview.trackHighlightTintColor = ColorScheme.armadaGreen
        sliderview.hideLabels = false
        sliderview.tag = 666
        updateSlider(sliderview: sliderview)
        self.view.addSubview(sliderview)
    }
    
    func goRightWithoutAnimation(){
        if let sliderview = self.view.viewWithTag(666) as? RangeSlider {
            matchData.sliderValues["max"] = sliderview.lowerValue
            matchData.sliderValues["min"] = sliderview.upperValue
            let minmax = sliderview.calcReverseValues()
            matchData.sliderValues["maxTrue"] = minmax.0.rounded()
            matchData.sliderValues["minTrue"] = minmax.1.rounded()
        }
        matchData.save()
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchSelectInterest") as! matchSelectInterest
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchTeam = self
        self.navigationController?.pushViewController(rightViewController, animated: false)
    }
    
    func goRight(){
        if let sliderview = self.view.viewWithTag(666) as? RangeSlider {
            matchData.sliderValues["max"] = sliderview.lowerValue
            matchData.sliderValues["min"] = sliderview.upperValue
            let minmax = sliderview.calcReverseValues()
            matchData.sliderValues["maxTrue"] = minmax.0.rounded()
            matchData.sliderValues["minTrue"] = minmax.1.rounded()
        }
        matchData.currentview += 1
        matchData.save()
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchSelectInterest") as! matchSelectInterest
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchTeam = self
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
        if let sliderview = self.view.viewWithTag(666) as? RangeSlider {
            matchData.sliderValues["max"] = sliderview.lowerValue
            matchData.sliderValues["min"] = sliderview.upperValue
            let minmax = sliderview.calcReverseValues()
            matchData.sliderValues["maxTrue"] = minmax.0.rounded()
            matchData.sliderValues["minTrue"] = minmax.1.rounded()
        }
        matchData.currentview -= 1
        matchData.save()
        self.matchTravel?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

