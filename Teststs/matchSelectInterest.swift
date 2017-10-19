//
//  matchSelectInterest.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-04.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchSelectInterest: UIViewController {
    
    @IBOutlet weak var stackHolder: UIView!
    //@IBOutlet weak var stackView: UIStackView!
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchTeam: matchTeam?
    let viewNumber = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStatusbar()
        swipes()
        if viewNumber < matchData.currentview {
            goRightWithoutAnimation()
        }
        
        var unfiltered = matchData.backendData["areas"] as! Array<Dictionary<String, AnyObject>>
        var filtered = Dictionary<String, Bool>()
        for item in unfiltered{
            filtered[item["area"] as! String] = false
        }
        
        var stackView = UIStackView()        
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 30
        for (key, _) in filtered{
            let area = createAreaView(text: key)
            print("adding \(area) to stackView")
            stackView.addArrangedSubview(area)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackHolder.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: stackHolder.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: stackHolder.centerXAnchor).isActive = true
    }
    func createAreaView(text:String) -> UIView {
        var areaView = UIView()
        
        let areaTitle = UILabel()
        let areaText = NSMutableAttributedString(
            string: text,
            attributes: [NSFontAttributeName:UIFont(
                name: "Lato-Regular",
                size: 22.0)!])
        areaTitle.attributedText = areaText
        areaTitle.textAlignment = .center
        areaTitle.translatesAutoresizingMaskIntoConstraints = false
        areaView.addSubview(areaTitle)
        let horizontalConstraint = NSLayoutConstraint(item: areaTitle, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: areaView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: areaTitle, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: areaView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        areaView.addConstraints([horizontalConstraint, verticalConstraint])
        areaView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        areaView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        areaView.backgroundColor = .white
        return areaView
    }
    
    func addStatusbar() {
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
    }
    
    func swipes(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func goRightWithoutAnimation(){
        if matchData.interestList.count == 0 {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEnd") as! matchEnd
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchSelectInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: false)
        } else {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchSelectInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: false)
        }
    }

    func goRight(){
        matchData.currentview += 1
        matchData.interestList = []
        for (key, value) in matchData.interestBools {
            if value == true{
                matchData.interestList.append(key)
            }
        }
        matchData.save()
        if matchData.interestList.count == 0 {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEnd") as! matchEnd
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchSelectInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: true)
        } else {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchSelectInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: true)
        }
    }
    
    func goBack(){
        matchData.currentview -= 1
        matchData.save()
        // send data back to previous view-controller
        self.matchTeam?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
