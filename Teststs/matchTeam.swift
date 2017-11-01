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
    @IBOutlet weak var rangeslider: RangeSlider!
    
    @IBAction func rangesliderAction(_ sender: Any) {
        print("uppervalue is: \(rangeslider.upperValue)")
        print("lowervalue is: \(rangeslider.lowerValue)")
        
    }
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLead: NSLayoutConstraint!
    
    @IBAction func changeValue(_ sender: UISlider) {
        slider.value = roundf(slider.value)
        
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
        
        print(matchData.currentview)
        if viewNumber < matchData.currentview {
            goRightWithoutAnimation()
        }
        
        
        matchData.slider = ["max": 400, "min": 0, "question": "Do you want to work for a smaller or larger employer?", "logarithmic":false, "units": false]
        
        // setup slider
        rangeslider.labelFontSize = 30
        rangeslider.maximumValue = Double(matchData.slider["max"] as! Int)
        rangeslider.minimumValue = Double(matchData.slider["min"] as! Int)
        let attributedTitel = NSMutableAttributedString(
            string: self.matchData.slider["question"] as! String,
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeueRegular",
                size: 35)!])
        titleLabel.attributedText = attributedTitel
        //        rangeslider.trackTintColor = ColorScheme.armadaGreen
        rangeslider.trackHighlightTintColor = ColorScheme.armadaGreen
    }
    
    func goRightWithoutAnimation(){
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchSelectInterest") as! matchSelectInterest
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchTeam = self
        self.navigationController?.pushViewController(rightViewController, animated: false)
    }
    
    func goRight(){
        matchData.currentview += 1
        matchData.save()
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchSelectInterest") as! matchSelectInterest
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchTeam = self
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
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

