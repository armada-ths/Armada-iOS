//
//  matchLoading.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-10-27.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.
//

import UIKit

class matchLoading: UIViewController {
    @IBOutlet var loadingLabel: UILabel!
    var matchData: matchDataClass = matchDataClass()
    var matchStart: matchStart?
    var matchDone: matchDoneViewController?
    let viewNumber = 9

    @IBOutlet var activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup status bar
        let statusView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height: 20.0))
        statusView.backgroundColor = .black
        self.view.addSubview(statusView)
        loadingLabel.font = UIFont(name:"BebasNeueRegular", size: 40)
        let transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
        activity.transform = transform

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func askForResult(){
        let student_id = 1
        let getput = matchGetPut(matchData: self.matchData)
        getput.getResult(student_id: student_id, finished: { isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    self.matchData.currentview += 1
                    self.matchData.save()
                    print("HEJ")
                    let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "matchResult") as! matchExhibitors
                    rightViewController.matchData = self.matchData
                    rightViewController.matchStart = self.matchStart
                    rightViewController.matchLoading = self
                    self.navigationController?.pushViewController(rightViewController, animated: true)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myAlert = storyboard.instantiateViewController(withIdentifier: "alert")
                myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(myAlert, animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "NO ANSWER", message: "wait for 10 seconds and try to fetch again", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                sleep(10)
                self.askForResult()
            }
        })
    }
    func goBackWithoutAnimation(){
        matchData.save()
        // send data back to previous view-controller
        self.matchDone?.matchData = matchData
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ( matchData.currentview  < viewNumber){
            goBackWithoutAnimation()
            return
        }

        self.askForResult()
    }
    
    
    func goBack(){
        matchData.currentview -= 1
        matchData.save()
        self.navigationController?.popViewController(animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
