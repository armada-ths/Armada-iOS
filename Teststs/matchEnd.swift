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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        matchData.teamSize = matchData.teamSize + 1
        matchData.currentview -= 1
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: String(matchData.currentview + 1)), object: matchData)
    }
    
}
