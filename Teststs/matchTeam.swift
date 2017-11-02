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
    // sliderview goes here
    @IBOutlet weak var dotsimage: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        print("headerview.bounds.height = \(headerview.bounds.height)")
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
        
        print(matchData.currentview)
        if viewNumber < matchData.currentview {
            goRightWithoutAnimation()
        }
        let attributedTitel = NSMutableAttributedString(
            string: self.matchData.slider["question"] as! String,
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeueRegular",
                size: 35)!])
        titleLabel.attributedText = attributedTitel
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
        sliderview.maximumValue = Double(self.matchData.slider["max"] as! Int)
        sliderview.minimumValue = Double(self.matchData.slider["min"] as! Int)
        sliderview.upperValue = 200
        sliderview.lowerValue = 0
        sliderview.knobSize = 2
        sliderview.trackHighlightTintColor = ColorScheme.armadaGreen
        sliderview.hideLabels = false
        sliderview.tag = 666
        self.view.addSubview(sliderview)
        //        sliderview.translatesAutoresizingMaskIntoConstraints = false
        //        let margins = self.view.layoutMarginsGuide
        //        sliderview.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        //        sliderview.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        //        sliderview.widthAnchor.constraint(equalToConstant: 200).isActive = true
        //        sliderview.heightAnchor.constraint(equalToConstant: 400).isActive = true
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

