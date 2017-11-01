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
    @IBOutlet var bottomHeight: NSLayoutConstraint!
    @IBOutlet var whenLabel: UILabel!
    @IBOutlet var topHeight: NSLayoutConstraint!
    @IBOutlet var doubleCheck: UILabel!
    @IBOutlet var almostDone: UILabel!
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchInterest: matchInterest?
    let viewNumber = 8
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
        print(matchData.currentview)
        if ( matchData.currentview  > viewNumber){
            goRightWithoutAnimation()
        }
        self.setupSwipe()
        self.setupStatusBar()
        almostDone.font = UIFont(name: "BebasNeueRegular", size: 40)
        topHeight.constant = UIScreen.main.bounds.width * (367/392)
     //   doubleCheck.text = "You can swipe right and double check your answers\n\n and when you are done:"
        bottomHeight.constant = topHeight.constant
        doubleCheck.font = UIFont(name: "BebasNeueLight", size: 30)
        whenLabel.font = UIFont(name: "BebasNeueLight", size: 30)
        doneButton.titleLabel?.font = UIFont(name: "BebasNeueRegular", size: 25)
        doneButton.layer.shadowColor = UIColor.black.cgColor
        doneButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        doneButton.layer.shadowRadius = 5
        if ( matchData.currentview  < viewNumber){
            goBackWithoutAnimation()
        }

    }
    
    func goRightWithoutAnimation(){
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchLoading") as! matchLoading
        rightViewController.matchData = self.matchData
        rightViewController.matchStart = matchStart
        rightViewController.matchDone = self
        self.navigationController?.pushViewController(rightViewController, animated: false)
    }
    
    @IBAction func loading(_ sender: Any) {
        // get or create UUID()
        
        let student_id = 666
        // send data to server
        
        let getput = matchGetPut(matchData: self.matchData)
        getput.putAnswer(student_id: student_id, finished: {isSuccess in
            if isSuccess {
                print("we got 200 back")
                
                // execute in main thread
                
                DispatchQueue.main.async {
                    self.matchData.currentview += 1
                    self.matchData.save()
                    let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchLoading") as! matchLoading
                    rightViewController.matchData = self.matchData
                    rightViewController.matchStart = self.matchStart
                    rightViewController.matchDone = self
                    self.navigationController?.pushViewController(rightViewController, animated: true)
                }
                
            } else {
                let alertController = UIAlertController(title: "Server Error", message: "Something went wrong when sending data to the server ☹️ \n push button to try again 😘", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                print("we got something else back")
            }
        }
    )}
    
//
//    func goRight(){
//        matchData.currentview += 1
//        matchData.save()
//        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchEnd") as! matchEnd
//        rightViewController.matchData = self.matchData
//        rightViewController.matchStart = matchStart
//        rightViewController.matchDone = self
//        self.navigationController?.pushViewController(rightViewController, animated: true)
//    }
    
    func goBack(){
        matchData.currentview -= 1
        matchData.save()
        self.matchInterest?.matchData = matchData
        self.navigationController?.popViewController(animated: true)
    }
    
    func goBackWithoutAnimation(){
        matchData.save()
        // send data back to previous view-controller
        self.matchInterest?.matchData = matchData
        self.navigationController?.popViewController(animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
