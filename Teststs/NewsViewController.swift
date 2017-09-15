//
//  TestNewsViewController.swift
//  Armada
//
//  Created by Ola Roos on 22/05/17.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

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

extension NewsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    func updateFunc(){
        ArmadaApi.newsFromServer(){
            news, error, errorMessage in
            OperationQueue.main.addOperation {[weak self] in
                self?.tableView.stopActivityIndicator()
                
                if(error == true){
                    self?.tableView.showEmptyMessage(errorMessage)
                    self?.news = []
                    self?.tableView.reloadData()
                }
                else{
                    self?.news = news as! [News]
                    self?.tableView.reloadData()
                }

            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = news[indexPath.row].featured == true ? "largeNewsCell" : "smallNewsCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NewsCell
        cell.newsItem = news[indexPath.row]
        return cell as! UITableViewCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {

        if let controller = segue.destination as? ScrollNewsViewController,
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            if (news[indexPath.row].content == ""){
                ArmadaApi.newsContentFromServer(contentUrl: news[indexPath.row].contentUrl) {
                    content in
                    self.news[indexPath.row].content = content
                }
            }
            controller.news = news[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    
    
}
