//
//  CompanySplitViewController.swift
//  Teststs
//
//  Created by Sami Purmonen on 01/06/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit

class CompanySplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    
    var shouldCollapse = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        return shouldCollapse
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
