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
    
    @IBOutlet weak var positionLabel: UILabel!
    
    var company: Company? = nil
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        positionLabel.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToFavorites(sender: UIButton) {
        sender.resignFirstResponder()
//        FavoriteCompanies.append(selectedCompany!.name)
//        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        positionLabel.text = "\(find(companies, company!)!+1)/\(companies.count)"
        logoImageView.image = company?.image
        descriptionLabel.text = company?.description
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        parentViewController!.title = company!.name
//        positionLabel.hidden = false
        
        UIView.animateWithDuration(0.5) {
            self.positionLabel.alpha = 1
        }
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animateWithDuration(0.5) {
            self.positionLabel.alpha = 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            FavoriteCompanies.append(company!.name)
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.frame = CGRectMake(0, 0, cell.frame.width, 0)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return navigationController!.navigationBar.frame.maxY
        }
        if contains(FavoriteCompanies, company!.name) && indexPath.row == 3 {
            return 0
        } else {
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
