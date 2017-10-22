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
    @IBOutlet weak var asiaButton: UIButton!
    @IBOutlet weak var sAmericaButton: UIButton!
    @IBOutlet weak var oceaniaButton: UIButton!
    @IBOutlet weak var nAmericaButton: UIButton!
    @IBOutlet weak var africaButton: UIButton!
    var europe = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if(sender.layer.backgroundColor == ColorScheme.worldMatchGrey.cgColor){
            sender.layer.backgroundColor = UIColor.white.cgColor
        }
        else{
            sender.layer.backgroundColor = ColorScheme.worldMatchGrey.cgColor
        }
    }
}
