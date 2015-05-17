//
//  CatalogueTableViewController.swift
//  Teststs
//
//  Created by Sami Purmonen on 16/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit


struct Company {
    let name: String
    let description: String
    
    var image: UIImage {
        let name2 = name.stringByReplacingOccurrencesOfString(" ", withString: "-", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil).lowercaseString
        return UIImage(named: "\(name2)-logo.png")!
    }
}

var selectedCompany: Company?

class CatalogueTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let companies = [
        Company(name: "ABB", description: "Power and automation technologies."),
        Company(name: "Accenture", description: "Management consulting and outsourcing."),
        Company(name: "Academic Work", description: "Young professionals consulting."),
        Company(name: "Adecco", description: "Human resource consulting."),
        Company(name: "Capgemini", description: "Consulting, technology and outsourcing services."),
        Company(name: "Ericsson", description: "Communications technology and services."),
        Company(name: "Volvo", description: "Transportation related products and services."),
        Company(name: "Combitech", description: "Consultancy combining technology, environment and security."),
        Company(name: "Cybercom", description: "IT consulting company."),
        Company(name: "Arla Foods", description: "Farmer owned dairy company."),
        Company(name: "Astra Zeneca", description: "Innovation-driven, integrated biopharmaceutical company."),
        ].sorted { $0.name < $1.name }
    
//    var letters = [String]()
//    var companiesByLetters = [(letter: "", companies: [Company(name: "", description: "")])]
    var companiesByLetters: [(letter: String, companies: [Company])] = []

    
    func updateCompaniesByLetters(companies: [Company]) {
        companiesByLetters = Array(Set(companies.map { String($0.name[$0.name.startIndex]) })).sorted {$0 < $1}.map { letter in (letter: letter, companies: companies.filter({ $0.name.hasPrefix(letter) })) }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        updateCompaniesByLetters(companies)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
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

    

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return companiesByLetters[section].letter
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        
    }

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
    }
}


extension CatalogueTableViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println(searchText)
        if searchText.isEmpty {
            updateCompaniesByLetters(companies)
        } else {
            updateCompaniesByLetters(companies.filter({ $0.name.lowercaseString.hasPrefix(searchText.lowercaseString)}))
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
//        navigationController!.navigationBar.hidden = true
//        var r = self.view.frame
//        r.origin.y = -44
//        r.size.height += 44
//        
//        self.view.frame=r;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
//        navigationController!.navigationBar.hidden = false
//        var r = self.view.frame
//        r.origin.y = 0
//        r.size.height -= 44
//        
//        self.view.frame=r;
    }
    
}
