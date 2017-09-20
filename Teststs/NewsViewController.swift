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
        
        // fix header
        let frame = CGRect(x: 0,y: 0, width: 400, height: 100);
        let label = UILabel(frame: frame)
        let myMutableString = NSMutableAttributedString(
            string: "N E W S THS Armada 2017",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeue-Thin",
                size: 20.0)!])
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueBook", size: 20.0), range:NSRange(location: 0, length: 8))
        label.textAlignment = .center
        label.attributedText = myMutableString
        self.navigationItem.titleView = label
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
        
        let cellIdentifier = news[indexPath.row].featured == true ? "largeWhiteCell" : "smallWhiteCell"
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
