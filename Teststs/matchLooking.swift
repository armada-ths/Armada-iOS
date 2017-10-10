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
    
    override func viewWillAppear(_ animated: Bool) {
        let blockview = UIView(frame: CGRect(x:0, y:0, width: 100, height:(self.navigationController?.navigationBar.frame.height)! - 2))
        blockview.backgroundColor = ColorScheme.leilaDesignGrey
        blockview.tag = 666
        self.navigationController?.navigationBar.addSubview(blockview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = ColorScheme.leilaDesignGrey
        
        let lookingstring = NSMutableAttributedString(
            string: "What are you looking for?",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeueRegular",
                size: 22.0)!])
        lookingLabel.textAlignment = .center
        lookingLabel.attributedText = lookingstring
                
        if self.navigationItem.titleView == nil {
            let frame = CGRect(x: 0,y: 13, width: 200, height: 30);
            let label = UILabel(frame: frame)
            let myMutableString = NSMutableAttributedString(
                string: "M A T C H THS Armada 2017",
                attributes: [NSFontAttributeName:UIFont(
                    name: "BebasNeue-Thin",
                    size: 22.0)!])
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueRegular", size: 22.0), range:NSRange(location: 0, length: 10))
            label.textAlignment = .center
            label.attributedText = myMutableString
            let newTitleView = UIView(frame: CGRect(x: 0, y:0 , width: 200, height: 50))
            newTitleView.addSubview(label)
            self.navigationItem.titleView = newTitleView
        }

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        // do stuff with matchLooking
    
        self.setButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recieveData), name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: nil)
    }
    
    func setButtons(){
        print(self.matchData.lookingBool)
        partjobButton.isSelected = self.matchData.lookingBool["part-time job"]!
        summerjobButton.isSelected = self.matchData.lookingBool["summer job"]!
        thesisButton.isSelected = self.matchData.lookingBool["thesis"]!
        traineeButton.isSelected = self.matchData.lookingBool["trainee"]!
    }
    
    func recieveData(notification: NSNotification){
        print("in matchSelectInterest view")
        let data = notification.object as! matchDataClass
        self.matchData = data
        print("recieved data from first match interest view")
        matchData.currentInterest = 0
        print("matchData.currentview is \(matchData.currentview)")
    }
    
    func goRight(){
        print("going to matchSweden")
        matchData.currentview += 1
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchSweden") as! matchSweden
        rightViewController.matchData = self.matchData
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
        print("going back to matchStart")
        matchData.currentview -= 1
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: matchData)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.viewWithTag(666)?.removeFromSuperview()
    }
    
}
