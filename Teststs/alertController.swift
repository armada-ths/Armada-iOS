//
//  alertController.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-11-01.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.
//

import UIKit

class alertController: UIViewController {
    @IBOutlet var alertButton: UIButton!
    
    @IBOutlet var alertTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let alertText = "Thank you for matching with us!\n\nWe will now show you your matches, but it's up to you to talk to them at the fair\n\nSee you there!"
        alertTextView.text = alertText
        alertTextView.font = UIFont(name:"Lato-Light", size:20)
        alertButton.titleLabel?.font = UIFont(name: "BebasNeueBold", size: 30)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
