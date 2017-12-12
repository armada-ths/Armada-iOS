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
    let viewNumber = 1
    
    let latoDict:[Bool: String] = [false: "Lato-Regular", true: "Lato-Bold"]
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
        
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var dotsImg: UIImageView!
    
    @IBOutlet weak var b1tc: NSLayoutConstraint!
    @IBOutlet weak var b1lc: NSLayoutConstraint!
    @IBOutlet weak var b1w: NSLayoutConstraint!
    
    @IBOutlet weak var b2tc: NSLayoutConstraint!
    @IBOutlet weak var b2lc: NSLayoutConstraint!
    @IBOutlet weak var b2w: NSLayoutConstraint!
    
    @IBOutlet weak var b3tc: NSLayoutConstraint!
    @IBOutlet weak var b3lc: NSLayoutConstraint!
    @IBOutlet weak var b3w: NSLayoutConstraint!
    
    @IBOutlet weak var b4tc: NSLayoutConstraint!
    @IBOutlet weak var b4lc: NSLayoutConstraint!
    @IBOutlet weak var b4w: NSLayoutConstraint!
    
    var label1string: NSMutableAttributedString?
    var label2string: NSMutableAttributedString?
    var label3string: NSMutableAttributedString?
    var label4string: NSMutableAttributedString?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)

        if viewNumber < matchData.currentview {
            nextView(isAnimated: false)
        }
        
        self.navigationController?.navigationBar.tintColor = ColorScheme.leilaDesignGrey
        
        button1.setImage(#imageLiteral(resourceName: "match2pushedbutton"), for: UIControlState.selected)
        button2.setImage(#imageLiteral(resourceName: "match2pushedbutton"), for: UIControlState.selected)
        button3.setImage(#imageLiteral(resourceName: "match2pushedbutton"), for: UIControlState.selected)
        button4.setImage(#imageLiteral(resourceName: "match2pushedbutton"), for: UIControlState.selected)
        button1.setImage(nil, for: UIControlState.normal)
        button2.setImage(nil, for: UIControlState.normal)
        button3.setImage(nil, for: UIControlState.normal)
        button4.setImage(nil, for: UIControlState.normal)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        self.setButtons()
        label1string = NSMutableAttributedString(
            string: "Internship",
            attributes: [NSFontAttributeName:UIFont(
                name: latoDict[button1.isSelected]!,
                size: 18.0)!])
        label2string = NSMutableAttributedString(
            string: "Summer job",
            attributes: [NSFontAttributeName:UIFont(
                name: latoDict[button2.isSelected]!,
                size: 18.0)!])
        label3string = NSMutableAttributedString(
            string: "Part time job",
            attributes: [NSFontAttributeName:UIFont(
                name: latoDict[button3.isSelected]!,
                size: 18.0)!])
        label4string = NSMutableAttributedString(
            string: "Master thesis",
            attributes: [NSFontAttributeName:UIFont(
                name: latoDict[button4.isSelected]!,
                size: 18.0)!])
        label1.attributedText = label1string
        label2.attributedText = label2string
        label3.attributedText = label3string
        label4.attributedText = label4string
        
        let offset = CGFloat(20 + 20 + 14)
        repositionButtons(UIScreen.main.bounds.size.height -  offset - headerView.frame.height - dotsImg.frame.height)
    }
    
    func repositionButtons(_ height: CGFloat){
        let buttonimageW = height*0.071
        
        b1w.constant = buttonimageW
        b2w.constant = buttonimageW
        b3w.constant = buttonimageW
        b4w.constant = buttonimageW
        
        b1tc.constant = height*0.191  - buttonimageW/2.0
        b1lc.constant = height*0.0465 - buttonimageW/2.0
        
        b2tc.constant = height*0.3765 - buttonimageW/2.0
        b2lc.constant = height*0.1548  - buttonimageW/2.0
        
        b3tc.constant = height*0.586  - buttonimageW/2.0
        b3lc.constant = height*0.2987 - buttonimageW/2.0
        
        b4tc.constant = height*0.77175  - buttonimageW/2.0
        b4lc.constant = height*0.1117 - buttonimageW/2.0
    }
    
    func setButtons(){
        button1.isSelected = self.matchData.lookingBool["part-time job"]!
        button2.isSelected = self.matchData.lookingBool["summer job"]!
        button3.isSelected = self.matchData.lookingBool["thesis"]!
        button4.isSelected = self.matchData.lookingBool["trainee"]!
    }
    
    func goRight(){
        nextView(isAnimated: true)
    }
    
    func nextView(isAnimated: Bool){
        if isAnimated {
            self.matchData.currentview += 1
            self.matchData.save()
        }
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchSweden") as! matchSweden
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = self.matchStart
        rightViewController.matchLooking = self
        self.navigationController?.pushViewController(rightViewController, animated: isAnimated)
    }
    
    func goBack(){
        matchData.currentview -= 1
        matchData.save()
        self.matchStart?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func button1Push(_ sender: Any) {
        if button1.isSelected {
            button1.isSelected = false
        } else {
            button1.isSelected = true
        }
        self.matchData.lookingBool["part-time job"] = button1.isSelected
        label1string?.addAttributes([NSFontAttributeName:UIFont(
            name: latoDict[button1.isSelected]!,
            size: 18.0)!], range: NSRange(location: 0,length: (label1string?.length)!))
        label1.attributedText = label1string
        matchData.save()
    }
    @IBAction func button2Push(_ sender: Any) {
        if button2.isSelected {
            button2.isSelected = false
        } else {
            button2.isSelected = true
        }
        self.matchData.lookingBool["summer job"] = button2.isSelected
        label2string?.addAttributes([NSFontAttributeName:UIFont(
            name: latoDict[button2.isSelected]!,
            size: 18.0)!], range: NSRange(location: 0,length: (label2string?.length)!))
        label2.attributedText = label2string
        matchData.save()
    }
    @IBAction func button3Push(_ sender: Any) {
        if button3.isSelected {
            button3.isSelected = false
        } else {
            button3.isSelected = true
        }
        self.matchData.lookingBool["thesis"] = button3.isSelected
        label3string?.addAttributes([NSFontAttributeName:UIFont(
            name: latoDict[button3.isSelected]!,
            size: 18.0)!], range: NSRange(location: 0,length: (label3string?.length)!))
        label3.attributedText = label3string
        matchData.save()
    }
    @IBAction func button4Push(_ sender: Any) {
        if button4.isSelected {
            button4.isSelected = false
        } else {
            button4.isSelected = true
        }
        self.matchData.lookingBool["trainee"] = button4.isSelected
        label4string?.addAttributes([NSFontAttributeName:UIFont(
            name: latoDict[button4.isSelected]!,
            size: 18.0)!], range: NSRange(location: 0,length: (label4string?.length)!))
        label4.attributedText = label4string
        matchData.save()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
