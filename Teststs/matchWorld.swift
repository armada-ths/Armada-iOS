//
//  matchWorld.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-05.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchWorld: UIViewController {
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchSweden: matchSweden?
    let viewNumber = 3
    @IBOutlet weak var intrestAbroad: UISwitch!
    @IBOutlet weak var europeButton: UIButton!
    @IBOutlet var europeLabel: UILabel!
    @IBOutlet weak var asiaButton: UIButton!
    @IBOutlet var asiaLabel: UILabel!
    @IBOutlet weak var sAmericaButton: UIButton!
    @IBOutlet var sAmericaLabel: UILabel!
    @IBOutlet weak var oceaniaButton: UIButton!
    @IBOutlet var oceaniaLabel: UILabel!
    @IBOutlet weak var nAmericaButton: UIButton!
    @IBOutlet var nAmericaLabel: UILabel!
    @IBOutlet weak var africaButton: UIButton!
    @IBOutlet var africaLabel: UILabel!
    @IBOutlet var stackHeight: NSLayoutConstraint!
    
    @IBOutlet var stack1: NSLayoutConstraint!
    @IBOutlet var stack2: NSLayoutConstraint!
    @IBOutlet var stack3: NSLayoutConstraint!
    @IBOutlet var mapH: NSLayoutConstraint!
    @IBOutlet var mapW: NSLayoutConstraint!
    @IBOutlet var header: UIImageView!
    var labelArray = Array<UILabel>()
    var buttonArray = Array<UIButton>()
    
    @IBOutlet var buttonsDistance: NSLayoutConstraint!
    @IBOutlet var mapDistance: NSLayoutConstraint!
    var europe = false

    override func viewDidLoad() {
        super.viewDidLoad()
        labelArray = [europeLabel, asiaLabel, sAmericaLabel, oceaniaLabel, nAmericaLabel, africaLabel]
        buttonArray = [europeButton, asiaButton, sAmericaButton, oceaniaButton, nAmericaButton, africaButton]
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
       // let screenHeight = screenSize.height*(100/375)
        if(!intrestAbroad.isOn){
            for label in labelArray{
                label.alpha = 0.34
            }
            for button in buttonArray{
                button.alpha = 0.34
                button.layer.backgroundColor = UIColor.white.cgColor
                button.isEnabled = false
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
        
        print(matchData.currentview)
        if viewNumber < matchData.currentview {
            goRightWithoutAnimation()
        }
                
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
    @IBAction func checkBox(_ sender: UIButton) {
        let tag = sender.tag
        if(sender.layer.backgroundColor == ColorScheme.worldMatchGrey.cgColor){
            sender.layer.backgroundColor = UIColor.white.cgColor
            labelArray[tag].font = UIFont(name: "Lato-Light", size: 20)
        }
        else{
            sender.layer.backgroundColor = ColorScheme.worldMatchGrey.cgColor
            labelArray[tag].font = UIFont(name: "Lato-Regular", size: 20)
            
        }
    }
    
    @IBAction func switchState(_ sender: UISwitch) {
        if (sender.isOn == true){
            for label in labelArray{
                label.alpha = 1
            }
            for button in buttonArray{
                button.alpha = 1
                button.isEnabled = true
            }
        }
        else{
            for label in labelArray{
                label.alpha = 0.34
                label.font = UIFont(name: "Lato-Light", size: 20)

            }
            for button in buttonArray{
                button.alpha = 0.34
                button.layer.backgroundColor = UIColor.white.cgColor
                button.isEnabled = false
            }
        }
    }
}
