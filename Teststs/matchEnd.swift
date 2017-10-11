//
//  matchEnd.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-04.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchEnd: UIViewController {
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchInterest: matchInterest?
    var matchSelectInterest: matchSelectInterest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
        self.view.backgroundColor = ColorScheme.leilaDesignGrey
        
        let summarystring = NSMutableAttributedString(
            string: "SUMMARY",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeueRegular",
                size: 22.0)!])
        summaryLabel.textAlignment = .center
        summaryLabel.attributedText = summarystring
        
        let titlestring = NSMutableAttributedString(
            string: "You are interrested in",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeueRegular",
                size: 22.0)!])
        titleLabel.textAlignment = .center
        titleLabel.attributedText = titlestring
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func goBack(){
        print("going back")
        matchData.currentview -= 1
        if matchData.currentInterest > 0 {
            self.matchInterest?.matchData = matchData
        } else {
            self.matchSelectInterest?.matchData = matchData
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
