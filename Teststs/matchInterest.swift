//
//  matchInterest.swift
//  matchingExp
//
//  Created by Rebecca Forstén Klinc on 2017-10-27.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.
//

import UIKit

class matchInterest: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var areas: UICollectionView!
    //@IBOutlet weak var stackView: UIStackView!
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchSelectInterest: matchSelectInterest?
    let viewNumber = 7
    var mainAreas = [String]()
    var areaKeys = [Int: String]()
    var keys = [Int: String]()
    var numInterests = 0
    
    @IBOutlet var imageH: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if ( matchData.currentview  < viewNumber){
            goBackWithoutAnimation()
        }
        areas.delegate = self
        areas.dataSource = self
        addStatusbar()
        swipes()
        var i = 0
        for item in matchData.mainAreas{
            if (item.value == true){
                mainAreas.append(item.key)
            }
        }
        var index = 0
        var found = false
        for area in matchData.subAreas{
            found = false
            for mainArea in mainAreas{
                let areaObj = area.value as [String: Any]
                if(areaObj["parent"] as! String == mainArea){
                    found = true
                    areaKeys[areaObj["id"] as! Int] = areaObj["field"] as! String
                    keys[index] = String(describing: areaObj["id"]!)
                    index += 1
                    if(areaObj["select"] as! Bool == true){
                        numInterests += 1
                    }
                }

            }
            if(found == false) {
                matchData.subAreas[area.key]!["select"] = false
            }
        }
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
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchDone") as! matchDoneViewController
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchInterest = self
        print("going to matchEnd from withoutanimation")
        self.navigationController?.pushViewController(rightViewController, animated: false)
        
    }
    
    func goRight(){
        matchData.save()
        if(numInterests < 1){
            let alertController = UIAlertController(title: "Error", message: "You need to select more than 1 interest", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        matchData.currentview += 1
        matchData.areaListDynamic = []
        for (key, value) in matchData.areaBools {
            print("key is \(key)")
            if value == true{
                matchData.areaListDynamic.append(key)
            }
        }
        matchData.currentArea = 0
        matchData.areaListDynamic = matchData.areaListDynamic.reversed()
        
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchDone") as! matchDoneViewController
        
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
       // rightViewController.matchSelectInterest = self
        print("going to matchEnd from roRight()")
        self.navigationController?.pushViewController(rightViewController, animated: true)
        
    }
    
    func goBack(){
        matchData.currentview -= 1
        matchData.save()
        // send data back to previous view-controller
        self.matchSelectInterest?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    func goBackWithoutAnimation(){
        matchData.save()
        // send data back to previous view-controller
        self.matchSelectInterest?.matchData = matchData
        self.navigationController?.popViewController(animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: UIScreen.main.bounds.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "intrestCollectionReusableView", for: indexPath) as! interestHeader
        cell.headerText.font = UIFont(name: "BebasNeueRegular", size: 35)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areaKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = areas.dequeueReusableCell(withReuseIdentifier: "areasCell", for: indexPath as IndexPath) as! IntrestCollectionViewCell
        cell.interest.setTitle(matchData.subAreas[keys[indexPath.row]!]!["field"] as! String, for: .normal)
        cell.interest.contentHorizontalAlignment = .left
        cell.interest.tag = Int(keys[indexPath.row]!)!
        cell.selectionButton.layer.cornerRadius = 0.5 * cell.selectionButton.bounds.size.width
        cell.selectionButton.layer.borderWidth = 1
        cell.selectionButton.layer.borderColor = UIColor.black.cgColor
        cell.selectionButton.tag = Int(keys[indexPath.row]!)!
        cell.tag = indexPath.row
        cell.interest.titleLabel?.font = UIFont(name: "Lato-Light", size: 20)
        if (matchData.subAreas[keys[indexPath.row]!]!["select"] as! Bool == true){
            cell.selectionButton.backgroundColor = ColorScheme.worldMatchGrey
            cell.interest.titleLabel?.font = UIFont(name: "Lato-Regular", size: 20)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // NOTE:
        let sqWidth:CGFloat = UIScreen.main.bounds.width
        return CGSize(width: (sqWidth-5)/2, height: 100);
    }
    
    
    @IBAction func selectIntrest(_ sender: UIButton) {
        let intrestId = String(describing: sender.tag)
        if (matchData.subAreas[intrestId]!["select"] as! Bool == false){
            matchData.subAreas[intrestId]!["select"] = true
            numInterests += 1

        }
        else{
            matchData.subAreas[intrestId]!["select"] = false
            numInterests -= 1

        }
    }
    
}


