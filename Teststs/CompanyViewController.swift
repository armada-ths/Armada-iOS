//
//  CompanyViewController.swift
//  Teststs
//
//  Created by Sami Purmonen on 16/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit


class CompanyViewController: UITableViewController {

    @IBOutlet weak var cell1: UITableViewCell!
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var favoritesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        title = selectedCompany!.name
        logoImageView.image = selectedCompany!.image
        descriptionLabel.text = selectedCompany!.description
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToFavorites(sender: AnyObject) {
        FavoriteCompanies.append(selectedCompany!.name)
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()

    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if contains(FavoriteCompanies, selectedCompany!.name) && indexPath.row == 2 {
            favoritesButton.hidden = true
            return 0
        } else {
            if indexPath.row == 2 {
                favoritesButton.hidden = false
            }
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    

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
