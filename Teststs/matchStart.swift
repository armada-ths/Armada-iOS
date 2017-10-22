//
//  matchStart.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-04.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit
import SwiftyJSON

class matchStart: UIViewController {
    
    @IBOutlet weak var label1:UILabel!
    @IBOutlet weak var label2:UILabel!
    let viewNumber = 0
    var matchData: matchDataClass = matchDataClass()
    let label1title = NSMutableAttributedString(
        string: "There are more than 200 exhibitors at \nArmada Fair 21-22 November, \nwe will help you find the five best for you!",
        attributes: [NSFontAttributeName:UIFont(
            name: "Lato-Light",
            size: 18.0)!])
    let label2title = NSMutableAttributedString(
        string: "Start by swiping left",
        attributes: [NSFontAttributeName:UIFont(
            name: "Lato-Medium",
            size: 18.0)!])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorScheme.leilaDesignGrey
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)    
        
        
        if let match = self.matchData.load() {
            self.matchData = match
            self.matchData.currentview = 2
            print(" matchData.currentview = \(matchData.currentview)")
            if viewNumber < matchData.currentview {
                goRightWithoutAnimation()
            }
        }
        
        label1.textAlignment = .center
        label1.attributedText = label1title
        label2.textAlignment = .center
        label2.attributedText = label2title
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func goRightWithoutAnimation(){
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchLooking") as! matchLooking
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = self
        self.navigationController?.pushViewController(rightViewController, animated: false)
    }
    
    func goRight(){
        matchData.currentview += 1
        matchData.save()
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchLooking") as! matchLooking
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = self
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
        print("can't go back more, this is the initial view")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
