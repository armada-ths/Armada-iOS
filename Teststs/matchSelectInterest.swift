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
        
        var unfiltered = matchData.backendData["areas"] as! Array<Dictionary<String, Any>>
        var filteredAreas = Dictionary<String, Bool>()
        var filteredSubAreas = Dictionary<String, Array<Dictionary<String, Any>>>()
        
        // filter areas
        for item in unfiltered{
            filteredAreas[item["area"] as! String] = false
        }
        self.matchData.areaList = []
        for (key, _) in filteredAreas{
            filteredSubAreas[key] = []
            self.matchData.areaList.append(key)
            self.matchData.areaBools[key] = false
        }
        self.matchData.areaList = self.matchData.areaList.reversed()
        // filter sub-areas
        for item in unfiltered{
            var newItem = Dictionary<String, Any>()
            newItem["id"] = item["id"] as! Int
            newItem["work_field"] = item["work_field"] as! String
            newItem["bool"] = false
            filteredSubAreas[item["area"] as! String]?.append(newItem)
        }
        // setup stack-view
        var stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 30
        
        var count = matchData.areaList.count - 1
        for (key, _) in filteredAreas{
            let area = createAreaView(text: key, tag: count)
            count -= 1
            print("adding \(area) to stackView")
            stackView.addArrangedSubview(area)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackHolder.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: stackHolder.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: stackHolder.centerXAnchor).isActive = true
    }
    
    
    func createAreaView(text:String, tag:Int) -> UIView {
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
        
        // add tag and click-function
        areaView.tag = tag
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (someAction))
        areaView.addGestureRecognizer(gesture)
        
        return areaView
    }
    func someAction(sender: UITapGestureRecognizer){
        print("like flipping a flipping flipswitch broh!")
        let matchInt = sender.view!.tag as! Int
        print("sender.view!.tag \(sender.view!.tag)")
        print("matchInt \(matchInt)")
        let boolean = self.matchData.areaBools[self.matchData.areaList[matchInt]] as! Bool
        print("boolean \(boolean)")
        let area = self.matchData.areaList[matchInt]
        print("area \(area)")
        if boolean {
            self.matchData.areaBools[self.matchData.areaList[matchInt]] = false
        } else {
            self.matchData.areaBools[self.matchData.areaList[matchInt]] = true
        }
        
        print(self.matchData.areaBools[self.matchData.areaList[matchInt]])
        
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
        if matchData.areaList.count == 0 {
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
        matchData.areaListDynamic = []
        for (key, value) in matchData.areaBools {
            print("key is \(key)")
            if value == true{
                matchData.areaListDynamic.append(key)
            }
        }
        matchData.areaListDynamic = matchData.areaListDynamic.reversed()
        matchData.save()
        if matchData.areaListDynamic.count == 0 {
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
