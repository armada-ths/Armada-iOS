//
//  LocationViewController.swift
//  Armada
//
//  Created by Sami Purmonen on 05/11/15.
//  Copyright © 2015 Sami Purmonen. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var locationImageView: UIImageView!
    var company: Company!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationImageView.loadImageFromUrl(company.locationUrl)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
