//
//  BanquetTableViewController.swift
//  Armada
//
//  Created by Paul Griffin on 2016-11-07.
//  Copyright © 2016 Sami Purmonen. All rights reserved.
//

import UIKit

class BanquetTableViewController: UITableViewController, UISearchBarDelegate {

    
    var allPlacements =  [(table: Int, people: [ArmadaBanquetPlacement])]()
    var filteredPlacements =  [(table: Int, people: [ArmadaBanquetPlacement])]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 68
        load()
    }
    override func viewDidAppear(_ animated: Bool) {
        if (allPlacements.count == 0){
            load()
        }
    }
    
    func load(){
        self.view.hideEmptyMessage()
        self.view.startActivityIndicator()
        self.tableView.separatorStyle = .none
        ArmadaApi.banquetPlacementsFromServer {
            switch $0 {
            case .success(let placements):
                self.updateResults(placements: placements)
            case .error(let error):
                self.updateResults(placements: [], error: error )
                break
            }
        }
    }
    
    func updateResults(placements: [(table: Int, people: [ArmadaBanquetPlacement])], error: Error? = nil){
        OperationQueue.main.addOperation {
            if let error = error{
                self.view.showEmptyMessage(error.localizedDescription)
            } else {
                self.tableView.separatorStyle = .singleLine
                self.view.hideEmptyMessage()
            }
            self.view.stopActivityIndicator()
            self.allPlacements = placements.sorted { $0.0.table < $0.1.table }
            self.filteredPlacements = self.filterPlacements(placements: self.allPlacements, by: self.searchBar.text!)
            
            self.tableView.reloadData()
        }
    }
    
    //filter on exact table number match or approx firstname/lastname
    func filterPlacements(placements: [(table: Int, people: [ArmadaBanquetPlacement])], by searchTerm: String) -> [(table: Int, people: [ArmadaBanquetPlacement])]{
        if (searchTerm == "") { return placements }
        let tables = placements.filter { (table, people) in
            "\(table)" == searchTerm ||
                people.filter{ "\($0.firstName) \($0.lastName) \($0.jobTitle)".lowercased().contains(searchTerm.lowercased()) }.count > 0
            }.map { $0.table }
        return placements.filter { placement in tables.contains { placement.table == $0 } }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredPlacements.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlacements[section].people.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Table \(filteredPlacements[section].table)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BanquetTableViewCell", for: indexPath) as! BanquetTableViewCell
        let person = filteredPlacements[indexPath.section].people[indexPath.row]

        cell.nameLabel.text = "\(person.firstName) \(person.lastName)"
        cell.seatLabel.text = "Seat \(person.seat)"
        cell.jobTitleLabel.text = person.jobTitle
        
        cell.linkedInImageView?.isHidden = (person.linkedinUrl == nil)
        
        cell.contentView.layer.removeAllAnimations()
        if "\(person.firstName) \(person.lastName) \(person.jobTitle)".lowercased().contains(searchBar.text!.lowercased()) {
            UIView.animate(withDuration: 0.5, animations: {
                cell.contentView.backgroundColor = UIColor.lightGray
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    cell.contentView.backgroundColor = UIColor(hex: 0xeeeeee)
                })
            })
        }else{
            cell.contentView.backgroundColor = UIColor.white
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = filteredPlacements[indexPath.section].people[indexPath.row]
        if let url = person.linkedinUrl{
            UIApplication.shared.openURL(url)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateResults(placements: allPlacements)
    }
}
