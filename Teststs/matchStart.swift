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
    
    override func viewWillAppear(_ animated: Bool) {
        // if screens are already loaded jump ahead
        if viewNumber < matchData.currentview {
            self.nextView(isAnimated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = ColorScheme.leilaDesignGrey
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
        
        if let match = self.matchData.load() {
            self.matchData = match
            if viewNumber < matchData.currentview {
                nextView(isAnimated: false)
            }
        }
        
        label1.textAlignment = .center
        label1.attributedText = label1title
        label2.textAlignment = .center
        label2.attributedText = label2title
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func goRight(){
        nextView(isAnimated: true)
    }
    
    func nextView(isAnimated: Bool){
        if isAnimated {
            self.matchData.currentview += 1
            self.matchData.save()
        }
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchLooking") as! matchLooking
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = self
        self.navigationController?.pushViewController(rightViewController, animated: isAnimated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
