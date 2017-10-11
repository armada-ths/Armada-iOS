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
        print(self.matchData.currentview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)

        self.view.backgroundColor = ColorScheme.leilaDesignGrey
        
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
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.recieveData), name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: nil)
        
        
        // load old data if exists
        /*
         if let match = self.matchData.load() {
         self.matchData = match
         print(matchData.time)
         }
         */
    }
    
    
    func recieveData(notification: NSNotification){
        
//        print("recieved data")
//        let data = notification.object as! matchDataClass
//        self.matchData = data
//        print("matchData.currentview is \(matchData.currentview)")
//        print(matchData.time)
        
    }
    

    func goRight(){
        print("swiping left")
        matchData.currentview += 1
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
