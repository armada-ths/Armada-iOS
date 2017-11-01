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

    @IBOutlet var activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
                print("we got the data, no exhibitor list exists so you get a pop-up instead")
                let alertController = UIAlertController(title: "SUCCESS", message: "we got the data, no exhibitor list exists so you get a pop-up instead", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                self.goBack()
            } else {
                let alertController = UIAlertController(title: "NO ANSWER", message: "wait for 10 seconds and try to fetch again", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                sleep(10)
                self.askForResult()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.askForResult()
    }
    
    
    func goBack(){
        matchData.currentview -= 1
        matchData.save()
        self.navigationController?.popViewController(animated: true)
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
