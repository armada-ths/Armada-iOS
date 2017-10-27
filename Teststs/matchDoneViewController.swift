//
//  matchDoneViewController.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-10-25.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.
//

import UIKit

class matchDoneViewController: UIViewController {
    //@IBOutlet weak var stackView: UIStackView!
    @IBOutlet var doubleCheck: UILabel!
    @IBOutlet var almostDone: UILabel!
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchSelectInterest: matchSelectInterest?
    let viewNumber = 7
    @IBOutlet var doneButton: UIButton!
    
    func setupSwipe(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
       // let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
       // swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        //self.view.addGestureRecognizer(swipeLeft)
    }
    
    func setupStatusBar(){
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwipe()
        self.setupStatusBar()
        almostDone.font = UIFont(name: "BebasNeueBold", size: 30)
        doubleCheck.text = "You can swipe right and double check your answers\n\n and when you are done:"
        doubleCheck.font = UIFont(name: "BebasNeue-Thin", size: 30)
        
  
        
    }
    
    func goRightWithoutAnimation(){
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEnd") as! matchEnd
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchDone = self
        self.navigationController?.pushViewController(rightViewController, animated: false)
    }
    
    @IBAction func loading(_ sender: Any) {
        
        //First send data to server
        matchData.currentview += 1
        matchData.save()
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchLoading") as! matchLoading
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchDone = self
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    func goRight(){
        matchData.currentview += 1
        matchData.save()
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEnd") as! matchEnd
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchDone = self
        self.navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    func goBack(){
        matchData.currentview -= 1
        matchData.save()
        self.matchSelectInterest?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
