//
//  matchLooking.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-05.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchLooking: UIViewController {

    var matchData: matchDataClass = matchDataClass()
    var matchBackButton: UIBarButtonItem = UIBarButtonItem()
    var matchStart: matchStart?
    
    @IBOutlet weak var lookingLabel: UILabel!
    @IBAction func partjobPush(_ sender: Any) {
        if partjobButton.isSelected {
            partjobButton.isSelected = false
            
        } else {
            partjobButton.isSelected = true
        }
        self.matchData.lookingBool["part-time job"] = partjobButton.isSelected
    }
    @IBAction func summerjobPush(_ sender: Any) {
        if summerjobButton.isSelected {
            summerjobButton.isSelected = false
        } else {
            summerjobButton.isSelected = true
        }
        self.matchData.lookingBool["summer job"] = summerjobButton.isSelected
    }
    @IBAction func thesisPush(_ sender: Any) {
        if thesisButton.isSelected {
            thesisButton.isSelected = false
        } else {
            thesisButton.isSelected = true
        }
        self.matchData.lookingBool["thesis"] = thesisButton.isSelected
    }
    @IBAction func traineePush(_ sender: Any) {
        if traineeButton.isSelected {
            traineeButton.isSelected = false
        } else {
            traineeButton.isSelected = true
        }
        self.matchData.lookingBool["trainee"] = traineeButton.isSelected
    }
    @IBOutlet weak var partjobButton: UIButton!
    @IBOutlet weak var summerjobButton: UIButton!
    @IBOutlet weak var thesisButton: UIButton!
    @IBOutlet weak var traineeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
        self.navigationController?.navigationBar.tintColor = ColorScheme.leilaDesignGrey
        
        
        let lookingstring = NSMutableAttributedString(
            string: "What are you looking for?",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeueRegular",
                size: 22.0)!])
        lookingLabel.textAlignment = .center
        lookingLabel.attributedText = lookingstring
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        // do stuff with matchLooking
        self.setButtons()
        
    }
    
    func setButtons(){
        print(self.matchData.lookingBool)
        partjobButton.isSelected = self.matchData.lookingBool["part-time job"]!
        summerjobButton.isSelected = self.matchData.lookingBool["summer job"]!
        thesisButton.isSelected = self.matchData.lookingBool["thesis"]!
        traineeButton.isSelected = self.matchData.lookingBool["trainee"]!
    }
    
    func goRight(){
        print("going to matchSweden")
        matchData.currentview += 1
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchSweden") as! matchSweden
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = self.matchStart
        rightViewController.matchLooking = self
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
        print("going back to matchStart")
        matchData.currentview -= 1
        self.matchStart?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.viewWithTag(666)?.removeFromSuperview()
    }
    
}
