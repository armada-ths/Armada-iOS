//
//  matchInterest.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-04.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchInterest: UIViewController {
    
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchInterest: matchInterest?
    var matchSelectInterest: matchSelectInterest?
    let viewNumber = 7
    
    @IBOutlet weak var stackHolder: UIView!
    @IBOutlet weak var subAreaLabel: UILabel!
    
    override func viewDidLoad() {
        print("in matchInterrest!!!!")
        super.viewDidLoad()
        addStatusbar()
        swipes()
        print(matchData.currentview)
        print("matchData.currentArea: \(matchData.currentArea)")
        
        if (viewNumber + matchData.currentArea < matchData.currentview) {
            goRightWithoutAnimation()
        }
        
        let attribute:String = matchData.areaListDynamic[matchData.currentArea]
        subAreaLabel.text = attribute
        
        // setup stack-view
        var stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 30
        
        let area = self.matchData.areaList[self.matchData.currentArea]
        print(area)
        var count = 0
        for subareaDict in self.matchData.interrestList[area]!{
            let subarea = createSubAreaView(text: subareaDict["work_field"] as! String, tag: count)
            count += 1
            print("adding \(subarea) to stackView")
            stackView.addArrangedSubview(subarea)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackHolder.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: stackHolder.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: stackHolder.centerXAnchor).isActive = true
    }
    
    func createSubAreaView(text:String, tag:Int) -> UIView {
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
    
    func someAction(sender: UITapGestureRecognizer){
        let area = subAreaLabel.text
        print("like flipping a little flippin flipswitch broh!")
        let tag = sender.view!.tag as! Int
        print("sender.view!.tag \(sender.view!.tag)")
        let boolean = self.matchData.interrestList[area!]![tag]["bool"] as! Bool
        print("boolean \(boolean)")
        let subarea = self.matchData.interrestList[area!]![tag]["work_field"]
        print("area \(subarea)")
        if boolean {
            self.matchData.interrestList[area!]![tag]["bool"] = false
        } else {
            self.matchData.interrestList[area!]![tag]["bool"] = true
        }
        print(self.matchData.interrestList[area!]![tag]["bool"])
    }
        
    func goRightWithoutAnimation(){
        if matchData.areaListDynamic.count != (matchData.currentArea + 1) {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: false)
        } else {
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEnd") as! matchEnd
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: false)
        }
    }
    
    func goRight(){
        matchData.currentview += 1        
        if matchData.areaListDynamic.count != (matchData.currentArea + 1) {
            matchData.currentArea += 1
            matchData.save()
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: true)
        } else {
            matchData.save()
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEnd") as! matchEnd
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchInterest = self
            self.navigationController?.pushViewController(rightViewController, animated: true)
        }
    }
    
    func goBack(){
        matchData.currentview -= 1
        if self.matchData.currentArea == 0 {
            self.matchSelectInterest?.matchData = matchData
            matchData.save()
        } else {
            matchData.currentArea -= 1
            matchData.save()
            self.matchInterest?.matchData = matchData
        }        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
