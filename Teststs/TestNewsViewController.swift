//
//  TestNewsViewController.swift
//  Armada
//
//  Created by Ola Roos on 22/05/17.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class TestNewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var news: [News] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.startActivityIndicator()
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        updateFunc()
        
        // Do any additional setup after loading the view.
    }
}

extension TestNewsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    func updateFunc(){
        ArmadaApi.newsFromServer(){
            response in
            OperationQueue.main.addOperation {[weak self] in
                self?.tableView.stopActivityIndicator()
                
                switch response {
                case .success(let news):
                    self?.tableView.hideEmptyMessage()
                    self?.news = news
                    self?.tableView.reloadData()
                case .error(let error):
                    self?.tableView.showEmptyMessage(error.localizedDescription)
                    self?.news = []
                    self?.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = indexPath.row == 0 ? "largeNewsCell" : "smallNewsCell"

        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NewsCell
        cell.newsItem = news[indexPath.row]
        return cell as! UITableViewCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if let controller = segue.destination as? ScrollTestViewController,
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            controller.news = news[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    
    
}
