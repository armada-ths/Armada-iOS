//
//  ArmadaEventTableViewController.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-09-05.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.

import UIKit

class ArmadaEventTableViewController: UITableViewController, UISplitViewControllerDelegate {

    @IBOutlet weak var backBarButton: UIBarButtonItem!
    
    
    class ArmadaEventTableViewDataSource: ArmadaTableViewDataSource<ArmadaEvent> {
        
        var images:[String:UIImage] = [:]
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        
        var isFirstLoad = true
        
        override func updateFunc(_ callback: @escaping (Response<[[ArmadaEvent]]>) -> Void) {
            ArmadaApi.eventsFromServer { response in
                OperationQueue.main.addOperation {
                    callback(response.map { [$0] })
                    self.scrollToNearestUpcomingEventAnimated(!self.isFirstLoad)
                    self.isFirstLoad = false
                }
            }
        }
        
        func scrollToNearestUpcomingEventAnimated(_ animated: Bool) {
            var row = 0
            let dateFormat = "yyyy-MM-dd"
            let now = Date().format(dateFormat)
            let events = values.joined()
            for (i, event) in events.enumerated() {
                if event.startDate.format(dateFormat) >= now {
                    row = i
                    break
                }
            }
            if row != 0 {
                self.tableViewController?.tableView.scrollToRow(at: IndexPath(item: row, section: 0), at: .top, animated: animated)
            }
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let armadaEvent = values[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArmadaEventTableViewCell", for: indexPath) as! ArmadaEventTableViewCell
            cell.titleLabel.text = armadaEvent.title
            cell.dateLabel.text = armadaEvent.startDate.format("d")  + "\n" +
                armadaEvent.startDate.format("MMM") + "\n" +
                armadaEvent.startDate.format("y")
            cell.descriptionLabel.text = armadaEvent.signupStateString
            if let imageUrl = armadaEvent.imageUrl {
                if let image = images[imageUrl.absoluteString] {
                    cell.eventImageView.image = image
                } else{
                    cell.eventImageView.image = nil
                    imageUrl.getImage() { response in
                        OperationQueue.main.addOperation {
                            if case .success(let image) = response {
                                self.images[imageUrl.absoluteString] = image
                                if let cell = tableView.cellForRow(at: indexPath) as? ArmadaEventTableViewCell {
                                    cell.eventImageView.image = image
                                    cell.setNeedsLayout()
                                }
                            }
                        }
                    }
                }
            }
            return cell
        }
    }
    
    var dataSource: ArmadaEventTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        dataSource = ArmadaEventTableViewDataSource(tableViewController: self)
        tableView.dataSource = dataSource
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        splitViewController?.delegate = self        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if let controller = segue.destination as? EventDetailViewController,
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            let armadaEvent = dataSource[indexPath]
            controller.event = armadaEvent
            deselectSelectedCell()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.isUserInteractionEnabled = false
        super.viewWillAppear(animated)
        if dataSource.isEmpty {
            dataSource.refresh()
        }
        
        // change backbar button from "Back" to ""
        backBarButton.title = ""
        
        // reveal logo-image
        self.navigationController?.navigationBar.viewWithTag(1)?.isHidden = false
    }
}
