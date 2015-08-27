//
//  ArmadaViewController.swift
//  Teststs
//
//  Created by Sami Purmonen on 27/08/15.
//  Copyright © 2015 Sami Purmonen. All rights reserved.
//

import UIKit

class ArmadaViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var containedViewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containedViewControllers = ["NewsTableViewController", "AboutViewController"].map { self.storyboard!.instantiateViewControllerWithIdentifier($0) }
        segmentedControlChanged(segmentedControl)

        // Do any additional setup after loading the view.
    }

    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        let viewController = containedViewControllers[sender.selectedSegmentIndex]
        self.addChildViewController(viewController)
        viewController.view.frame = self.containerView.bounds
        self.containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
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
