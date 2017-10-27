//
//  matchSelectInterest.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-04.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class matchSelectInterest: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
 
    
    
    
    @IBOutlet var areas: UICollectionView!
    //@IBOutlet weak var stackView: UIStackView!
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchTeam: matchTeam?
    let viewNumber = 6
    var areaKeys = [Int: String]()
    var numInterests = 0
    
    @IBOutlet var imageH: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        areas.delegate = self
        areas.dataSource = self
        addStatusbar()
        swipes()
        var i = 0
        for item in matchData.mainAreas{
            areaKeys[i] = item.key
            i += 1
            if(item.value == true){
                numInterests += 1
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
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest
            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
        rightViewController.matchSelectInterest = self
            print("going to matchEnd from withoutanimation")
            self.navigationController?.pushViewController(rightViewController, animated: false)

    }

    func goRight(){
        matchData.save()
        if(numInterests < 1 || numInterests > 4){
            let alertController = UIAlertController(title: "Error", message: "You need to select between 1 and 4 interests", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            for subArea in matchData.subAreas{
                matchData.subAreas[subArea.key]!["select"] = false
            }

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
            let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchInterest") as! matchInterest

            rightViewController.matchData = self.matchData
            rightViewController.matchStart = matchStart
            rightViewController.matchSelectInterest = self
            print("going to matchEnd from roRight()")
            self.navigationController?.pushViewController(rightViewController, animated: true)

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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*(200/750))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "intrestCollectionReusableView", for: indexPath) as! UICollectionReusableView
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return matchData.mainAreas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        let cell = areas.dequeueReusableCell(withReuseIdentifier: "areasCell", for: indexPath as IndexPath) as! IntrestCollectionViewCell
        //cell.intrest = filteredAreas.keys[indexPath.row]
        cell.intrest.text = areaKeys[indexPath.row]
        cell.selectionButton.layer.cornerRadius = 0.5 * cell.selectionButton.bounds.size.width
        cell.selectionButton.layer.borderWidth = 1
        cell.selectionButton.layer.borderColor = UIColor.black.cgColor
        cell.selectionButton.tag = indexPath.row
        cell.tag = indexPath.row
        cell.intrest.font = UIFont(name: "Lato-Light", size: 20)
        if (matchData.mainAreas[areaKeys[indexPath.row]!]! == true){
            cell.selectionButton.backgroundColor = ColorScheme.worldMatchGrey
            cell.intrest.font = UIFont(name: "Lato-Regular", size: 20)
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // NOTE:
        // The left inset and right inset is set to 20 pixels in Storyboard.
        let sqWidth:CGFloat = UIScreen.main.bounds.width
        return CGSize(width: sqWidth, height: 50);
    }

    @IBAction func selectIntrest(_ sender: UIButton) {
        let intrestId = sender.tag
        let areaOfintrest = areaKeys[intrestId]
        if (matchData.mainAreas[areaOfintrest!] == false){
            sender.backgroundColor = ColorScheme.worldMatchGrey
            matchData.mainAreas[areaOfintrest!] = true
            matchData.areaList.append(areaOfintrest!)
            numInterests += 1
            
        }
        else{
            sender.backgroundColor = UIColor.clear
            matchData.mainAreas[areaOfintrest!] = false
            numInterests -= 1

        }
    }
    
}

