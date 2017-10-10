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
    
    var matchData: matchDataClass = matchDataClass()
   // @IBOutlet weak var matchBackButton:UIBarButtonItem!
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.viewWithTag(666)?.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorScheme.leilaDesignGrey
        
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
        
        var label1title = NSMutableAttributedString(
            string: "Swipe to",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeueRegular",
                size: 22.0)!])
        label1.textAlignment = .center
        label1.attributedText = label1title
        
        var label2title = NSMutableAttributedString(
            string: "start",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeueRegular",
                size: 22.0)!])
        label2.textAlignment = .center
        label2.attributedText = label2title

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recieveData), name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: nil)
        
        // load old data if exists
        /*
         if let match = self.matchData.load() {
         self.matchData = match
         print(matchData.time)
         }
         */
    }
    
    func recieveData(notification: NSNotification){
        print("recieved data")
        let data = notification.object as! matchDataClass
        self.matchData = data
        print("matchData.currentview is \(matchData.currentview)")
        print(matchData.time)
        
    }
    
    func goRight(){
        print("swiping left")
        matchData.currentview += 1
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchLooking") as! matchLooking
        rightViewController.matchData = self.matchData
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
