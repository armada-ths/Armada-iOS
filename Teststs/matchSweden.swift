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
    var buttonArray: Array<UIButton> = []

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    
    @IBOutlet weak var area1: UIImageView!
    @IBOutlet weak var area2: UIImageView!
    @IBOutlet weak var area3: UIImageView!
    @IBOutlet weak var area4: UIImageView!
    @IBOutlet weak var area5: UIImageView!
    @IBOutlet weak var area6: UIImageView!
    @IBOutlet weak var areasthlm: UIImageView!
    @IBOutlet weak var areagbg: UIImageView!
    @IBOutlet weak var areamalmo: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func colorButton(_ button:UIButton){
        if button.isSelected {
            button.backgroundColor = ColorScheme.armadaGreen
        } else {
            button.backgroundColor = .white
        }
    }
    func pressButton(_ button:UIButton){
        if button.isSelected {
            button.isSelected = false
            button.backgroundColor = .white
        } else {
            button.isSelected = true
            button.backgroundColor = ColorScheme.armadaGreen
        }
    }
    func saveButtonValues(){
        for idx in 0...(self.buttonArray.count-1) {
            let key = self.buttonArray[idx].currentAttributedTitle?.string
            let val = self.buttonArray[idx].isSelected as! Bool
            matchData.swedenBool[key!] = val
        }
    }
    func loadButtonValues(){
        for idx in 0...(self.buttonArray.count-1) {
            let key = self.buttonArray[idx].currentAttributedTitle
            let button = self.buttonArray[idx]
            button.isSelected = matchData.swedenBool[(key?.string)!] as! Bool
            colorButton(button)
        }        
    }
    @IBAction func button1action(_ sender: Any) {
        pressButton(button1)
        area6.isHidden = !button1.isSelected
        saveButtonValues()
    }
    @IBAction func button2action(_ sender: Any) {
        pressButton(button2)
        area5.isHidden = !button2.isSelected
        saveButtonValues()
    }
    @IBAction func button3action(_ sender: Any) {
        pressButton(button3)
        area3.isHidden = !button3.isSelected
        saveButtonValues()
    }
    @IBAction func button4action(_ sender: Any) {
        pressButton(button4)
        areasthlm.isHidden = !button4.isSelected
        saveButtonValues()
    }
    @IBAction func button5action(_ sender: Any) {
        pressButton(button5)
        area2.isHidden = !button5.isSelected
        saveButtonValues()
    }
    @IBAction func button6action(_ sender: Any) {
        pressButton(button6)
        area4.isHidden = !button6.isSelected
        saveButtonValues()
    }
    @IBAction func button7action(_ sender: Any) {
        pressButton(button7)
        areagbg.isHidden = !button7.isSelected
        saveButtonValues()
    }
    @IBAction func button8action(_ sender: Any) {
        pressButton(button8)
        area1.isHidden = !button8.isSelected
        saveButtonValues()
    }
    @IBAction func button9action(_ sender: Any) {
        pressButton(button9)
        areamalmo.isHidden = !button9.isSelected
        saveButtonValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(matchData.currentview)
        if viewNumber < matchData.currentview {
            goRightWithoutAnimation()
        }
        statusBar()
        swipe()
        
        buttonArray = [button1, button2, button3, button4, button5, button6, button7, button8, button9]
        let buttonNameArray = ["North norrland", "South norrland", "Svealand", "Stockholm", "Region West", "Region East", "Göteborg", "Region South", "Malmö"]
        
        // setup title
        let titleText = NSMutableAttributedString(
            string: "WHERE IN SWEDEN DO YOU WANT TO WORK?\n SELECT THE REGIONS",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeue-Thin",
                size: 26)!, NSForegroundColorAttributeName: UIColor.black])
        titleText.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueRegular", size: 26.0), range:NSRange(location: 0, length: 36))
        titleLabel.attributedText = titleText
        
        // setup buttons
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
        
        if matchData.swedenBool.count != 0 {
            print("loading")
            loadButtonValues()
            for button in buttonArray{
                button.isSelected = !button.isSelected
            }
            button1action(self)
            button2action(self)
            button3action(self)
            button4action(self)
            button5action(self)
            button6action(self)
            button7action(self)
            button8action(self)
            button9action(self)
        }
        
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
        print("going back to view #\(matchData.currentview)")
        self.matchLooking?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
