//
//  matchWorld.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-05.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchWorld: UIViewController {
    
    @IBOutlet var stack3X: NSLayoutConstraint!
    @IBOutlet var stack2X: NSLayoutConstraint!
    @IBOutlet var stack1X: NSLayoutConstraint!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchSweden: matchSweden?
    let viewNumber = 3
    @IBOutlet weak var intrestAbroad: UISwitch!
    @IBOutlet weak var europeButton: UIButton!
    @IBOutlet var europeLabel: UIButton!
    @IBOutlet weak var asiaButton: UIButton!
    @IBOutlet var asiaLabel: UIButton!
    @IBOutlet weak var sAmericaButton: UIButton!
    @IBOutlet var sAmericaLabel: UIButton!
    @IBOutlet weak var oceaniaButton: UIButton!
    @IBOutlet var oceaniaLabel: UIButton!
    @IBOutlet weak var nAmericaButton: UIButton!
    @IBOutlet var nAmericaLabel: UIButton!
    @IBOutlet weak var africaButton: UIButton!
    @IBOutlet var africaLabel: UIButton!
    @IBOutlet var stackHeight: NSLayoutConstraint!
    
    @IBOutlet var stack1: NSLayoutConstraint!
    @IBOutlet var stack2: NSLayoutConstraint!
    @IBOutlet var stack3: NSLayoutConstraint!
    @IBOutlet var mapH: NSLayoutConstraint!
    @IBOutlet var mapW: NSLayoutConstraint!
    @IBOutlet var header: UIImageView!
    var labelArray = [String: UIButton]()
    var buttonArray = [String: UIButton]()
    
    @IBOutlet var buttonsDistance: NSLayoutConstraint!
    @IBOutlet var mapDistance: NSLayoutConstraint!
    var areaArray = ["europe", "asia", "americaS", "oceania", "americaN", "africa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (matchData.currentview < viewNumber){
            goBackWithoutAnimation()
        }
        if viewNumber < matchData.currentview {
            goRightWithoutAnimation()
        }
        
        labelArray = ["europe": europeLabel, "asia": asiaLabel, "americaS": sAmericaLabel, "oceania": oceaniaLabel, "americaN": nAmericaLabel, "africa": africaLabel]
        buttonArray = ["europe": europeButton, "asia": asiaButton, "americaS": sAmericaButton, "oceania": oceaniaButton, "americaN": nAmericaButton, "africa": africaButton]
        for label in labelArray{
            label.value.contentHorizontalAlignment = .left
        }

        let screenSize = UIScreen.main.bounds
       // let screenHeight = screenSize.height*(100/375)
        let stackWidth = (screenSize.width/320) * 50
        stack1X.constant = stackWidth
        stack2X.constant = stackWidth
        stack3X.constant = stackWidth
        intrestAbroad.onTintColor = ColorScheme.armadaGreen
        if (matchData.worldIntrest == true){
            intrestAbroad.isOn = true
            for area in areaArray{
                if(matchData.worldBool[area] == nil){
                    continue
                }
                if((matchData.worldBool[area]))!{
                    buttonArray[area]?.layer.backgroundColor = ColorScheme.worldMatchGrey.cgColor
                    labelArray[area]?.titleLabel?.font = UIFont(name: "Lato-Regular", size: 20)
                    
                }
            }
        }
        if(!intrestAbroad.isOn){
            for label in labelArray{
                label.value.alpha = 0.34
                label.value.isEnabled = false
            }
            for button in buttonArray{
                button.value.alpha = 0.34
                button.value.layer.backgroundColor = UIColor.white.cgColor
                button.value.isEnabled = false
            }
        }
        
        headerHeight.constant = screenSize.width*(100/375)
        mapW.constant = screenSize.width * 0.8
        mapH.constant = mapW.constant * (179/385)
        buttonsDistance.constant = ((screenSize.width/320) - 1) * 100
      //  mapDistance.constant = ((screenSize.width/320) - 1) * 100
        stackHeight.constant = ((screenSize.width/320)) * 180
        stack1.constant = stackHeight.constant/3
        stack2.constant = stackHeight.constant/3
        stack3.constant = stackHeight.constant/3

        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
        
        
                
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
//        
//        self.matchData.worldBool["europe"]      = false
//        self.matchData.worldBool["asia"]        = false
//        self.matchData.worldBool["americaN"]    = false
//        self.matchData.worldBool["americaS"]    = false
//        self.matchData.worldBool["australia"]   = false
        
        //Setup buttons
        europeButton.layer.cornerRadius = 0.5 * europeButton.bounds.size.width
        europeButton.layer.borderWidth = 1
        europeButton.layer.borderColor = UIColor.black.cgColor
        
        asiaButton.layer.cornerRadius = 0.5 * asiaButton.bounds.size.width
        asiaButton.layer.borderWidth = 1
        asiaButton.layer.borderColor = UIColor.black.cgColor
        
        sAmericaButton.layer.cornerRadius = 0.5 * sAmericaButton.bounds.size.width
        sAmericaButton.layer.borderWidth = 1
        sAmericaButton.layer.borderColor = UIColor.black.cgColor
        
        oceaniaButton.layer.cornerRadius = 0.5 * oceaniaButton.bounds.size.width
        oceaniaButton.layer.borderWidth = 1
        oceaniaButton.layer.borderColor = UIColor.black.cgColor
        
        nAmericaButton.layer.cornerRadius = 0.5 * nAmericaButton.bounds.size.width
        nAmericaButton.layer.borderWidth = 1
        nAmericaButton.layer.borderColor = UIColor.black.cgColor
        
        africaButton.layer.cornerRadius = 0.5 * africaButton.bounds.size.width
        africaButton.layer.borderWidth = 1
        africaButton.layer.borderColor = UIColor.black.cgColor
    }

    func goBackWithoutAnimation(){
        matchData.save()
        // send data back to previous view-controller
        self.matchSweden?.matchData = matchData
        self.navigationController?.popViewController(animated: false)
    }
    
    func goRightWithoutAnimation(){
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchTravel") as! matchTravel
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchWorld = self
        self.navigationController?.pushViewController(rightViewController, animated: false)
    }
    
    func goRight(){
        matchData.currentview += 1
        matchData.save()
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchTravel") as! matchTravel
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchWorld = self
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
        matchData.currentview -= 1
        matchData.save()
        self.matchSweden?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func checkBox(_ sender: AnyObject) {
        let tag = sender.tag
        let key = areaArray[tag!]
        if(matchData.worldBool[key] == true){
            buttonArray[key]?.layer.backgroundColor = UIColor.white.cgColor
            labelArray[key]?.titleLabel?.font = UIFont(name: "Lato-Light", size: 20)
            matchData.worldBool[key] = false
        }
        else{
            buttonArray[key]?.layer.backgroundColor = ColorScheme.worldMatchGrey.cgColor
            labelArray[key]?.titleLabel?.font = UIFont(name: "Lato-Regular", size: 20)
            matchData.worldBool[key] = true

            
        }
    }
    
    @IBAction func switchState(_ sender: UISwitch) {
        if (sender.isOn == true){
            matchData.worldIntrest = true
            for label in labelArray{
                label.value.alpha = 1
                label.value.isEnabled = true
            }
            for button in buttonArray{
                button.value.alpha = 1
                button.value.isEnabled = true
            }
        }
        else{
            matchData.worldIntrest = false
            for label in labelArray{
                matchData.worldBool[label.key] = false
                label.value.alpha = 0.34
                label.value.titleLabel?.font = UIFont(name: "Lato-Light", size: 20)
                label.value.isEnabled = false

            }
            for button in buttonArray{
                button.value.alpha = 0.34
                button.value.layer.backgroundColor = UIColor.white.cgColor
                button.value.isEnabled = false
            }
        }
    }
}
