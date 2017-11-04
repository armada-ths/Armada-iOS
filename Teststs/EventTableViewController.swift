//
//  ArmadaEventTableViewController.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-09-05.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.

import UIKit
import Foundation

class EventTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    
    
    class ArmadaEventTableViewDataSource: ArmadaTableViewDataSource<ArmadaEvent> {
        let armadaColours = [ ColorScheme.armadaLicorice, ColorScheme.armadaGreen, ColorScheme.armadaRed]
        var images:[String:UIImage] = [:]
        
        override init(tableViewController: UITableViewController) {
            super.init(tableViewController: tableViewController)
        }
        
        
        var isFirstLoad = true
        
        override func updateFunc(_ callback: @escaping (Response<[[ArmadaEvent]]>) -> Void) {
            ArmadaApi.eventsFromServer { response in
                OperationQueue.main.addOperation {
                    callback(response.map { [$0] })
                    self.isFirstLoad = false
                }
            }
        }
        
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return values[section].count + 1
        }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if(indexPath.row >= values[(indexPath as NSIndexPath).section].count){
                let cell = tableView.dequeueReusableCell(withIdentifier: "bottomCell", for: indexPath) as! UITableViewCell
                cell.sizeToFit()
                return cell
            }
            let armadaEvent = values[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventcell", for: indexPath) as! EventTableViewCell
            cell.eventItem = armadaEvent
            let eventColour = armadaColours[indexPath.row % 3]
            cell.backgroundColor = eventColour
            cell.daysLeftLabel.backgroundColor = eventColour
           cell.layer.zPosition = CGFloat(values[(indexPath as NSIndexPath).section].count - indexPath.row)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.dateView.backgroundColor = eventColour
            cell.dateLabel.backgroundColor = eventColour
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none

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

        
        // set title if not set
        if self.navigationItem.titleView == nil {
            
            let frame = CGRect(x: 0,y: 9, width: 200, height: 30);
            let label = UILabel(frame: frame)
            let myMutableString = NSMutableAttributedString(
                string: "E V E N T S",
                attributes: [NSFontAttributeName:UIFont(
                    name: "BebasNeue-Thin",
                    size: 22.0)!])
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueRegular", size: 22.0), range:NSRange(location: 0, length: 12))
//            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueRegular", size: 22.0), range:NSRange(location: 0, length: 0))
            label.textAlignment = .center
            label.attributedText = myMutableString
            let newTitleView = UIView(frame: CGRect(x: 0, y:0 , width: 200, height: 50))
            newTitleView.addSubview(label)
            self.navigationItem.titleView = newTitleView
        }
        
    }
}
