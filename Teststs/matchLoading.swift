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
        loadingLabel.font = UIFont(name:"BebasNeueRegular", size: 30)
        let transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        activity.transform = transform

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(10)
        goBack()

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
