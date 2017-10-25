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
    
    let summarystring = NSMutableAttributedString(
        string: "SUMMARY",
        attributes: [NSFontAttributeName:UIFont(
            name: "BebasNeueRegular",
            size: 22.0)!])
    let titlestring = NSMutableAttributedString(
        string: "You are interrested in",
        attributes: [NSFontAttributeName:UIFont(
            name: "BebasNeueRegular",
            size: 22.0)!])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
        self.view.backgroundColor = ColorScheme.leilaDesignGrey
        
        print(matchData.currentview)
        
        summaryLabel.textAlignment = .center
        summaryLabel.attributedText = summarystring
        
        titleLabel.textAlignment = .center
        titleLabel.attributedText = titlestring
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func goBack(){
        matchData.currentview -= 1
        matchData.save()
        if matchData.areaListDynamic.count > 0 {
            self.matchInterest?.matchData = matchData
        } else {
            self.matchSelectInterest?.matchData = matchData
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
