//
//  CatalogueTableViewController.swift
//  Teststs
//
//  Created by Sami Purmonen on 16/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit


var selectedCompany: Company?


class CatalogueTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allCompanies = DataDude.companiesFromServer()!
    
    
    var companies:[Company]
    
    required init!(coder aDecoder: NSCoder!) {
        companies = allCompanies
        super.init(coder: aDecoder)
    }
    
    //    companies = DataDude().companiesFromServer()!
    
    //    var letters = [String]()
    //    var companiesByLetters = [(letter: "", companies: [Company(name: "", description: "")])]
    var companiesByLetters: [(letter: String, companies: [Company])] = []
    
    
    func updateCompaniesByLetters(companies: [Company]) {
        companiesByLetters = Array(Set(companies.map { String($0.name[$0.name.startIndex]) })).sorted {$0 < $1}.map { letter in (letter: letter, companies: companies.filter({ $0.name.hasPrefix(letter) })) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        //        tableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    func updateFavorites() {
        companies = allCompanies.filter { contains(FavoriteCompanies, $0.name) }
        updateCompaniesByLetters(companies)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if isFavorites {
            tableView.sectionHeaderHeight = 0
            updateFavorites()
            searchBar.placeholder = "Search Favorites"
            updateFavoritesUI()
            navigationItem.rightBarButtonItem?.title = nil
        } else {
            var filteredCompanies = companies
            if CompanyFilter.applyFilter {
                if let education = CompanyFilter.education {
                    println("Filtering with education: \(education)")
                    filteredCompanies = companies.filter { contains($0.programmes, education) }
                }
                
                println("Companies for education \(filteredCompanies.count)")
                if let job = CompanyFilter.jobs.first {
                    println("Filtering with job: \(job)")
                    filteredCompanies = filteredCompanies.filter { contains($0.jobTypes, job) }
                }
            }
            println("Companies \(filteredCompanies.count)")
            updateCompaniesByLetters(filteredCompanies)
        }
        tableView.reloadData()
    }
    
    func updateFavoritesUI() {
        if FavoriteCompanies.isEmpty {
            let label = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
            label.text = "No Favorites"
            label.textAlignment = .Center
            label.sizeToFit()
            label.textColor = UIColor.lightGrayColor()
            label.font = UIFont.systemFontOfSize(30)
            searchBar.hidden = true
            tableView.backgroundView = label
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            searchBar.hidden = false
        }
    }
    
    var isFavorites: Bool {
        return restorationIdentifier == "Favorites"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return companiesByLetters.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return companiesByLetters[section].companies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyTableViewCell", forIndexPath: indexPath) as! CompanyTableViewCell
        
        let company = companiesByLetters[indexPath.section].companies[indexPath.row]
        cell.descriptionLabel.text = company.description.substringToIndex(advance(company.description.endIndex,-1))
        cell.logoImageView.image = company.image
        return cell
    }
    
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return isFavorites ? [] : companiesByLetters.map { $0.letter }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return companiesByLetters[section].letter
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return isFavorites
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            FavoriteCompanies.remove(companiesByLetters[indexPath.section].companies[indexPath.row].name)
            let deleteSection = companiesByLetters[indexPath.section].companies.count == 1
            tableView.beginUpdates()
            updateFavorites()
            if deleteSection {
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: FavoriteCompanies.isEmpty ? .None : .Fade)
                if FavoriteCompanies.isEmpty {
                    updateFavoritesUI()
                }
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            tableView.endUpdates()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow() {
            selectedCompany = companiesByLetters[indexPath.section].companies[indexPath.row]
        }
        (segue.destinationViewController as? CompaniesPageViewController)?.companies = companies
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
    }
}


extension CatalogueTableViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            updateCompaniesByLetters(companies)
        } else {
            updateCompaniesByLetters(companies.filter({ $0.name.lowercaseString.hasPrefix(searchText.lowercaseString)}))
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
}
