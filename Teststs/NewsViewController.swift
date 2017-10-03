//
//  TestNewsViewController.swift
//  Armada
//
//  Created by Ola Roos on 22/05/17.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit
protocol NewsCell {
    var newsItem:News? {get set};
}

class NewsViewController: UITableViewController {
    var news: [News] = []
    
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    
    func refresh(sender:AnyObject)
    {
        updateFunc()
        refreshControl?.endRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        // change backbar button from "Back" to ""
        backBarButton.title = ""
        
        // reveal logo-image
        self.navigationController?.navigationBar.viewWithTag(1)?.isHidden = false
        
        // set title if not set
        if self.navigationItem.titleView == nil {
            let frame = CGRect(x: 0,y: 13, width: 200, height: 30);
            let label = UILabel(frame: frame)
            let myMutableString = NSMutableAttributedString(
                string: "N E W S THS Armada 2017",
                attributes: [NSFontAttributeName:UIFont(
                    name: "BebasNeue-Thin",
                    size: 22.0)!])
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueRegular", size: 22.0), range:NSRange(location: 0, length: 8))
            label.textAlignment = .center
            label.attributedText = myMutableString
            let newTitleView = UIView(frame: CGRect(x: 0, y:0 , width: 200, height: 50))
            newTitleView.addSubview(label)
            self.navigationItem.titleView = newTitleView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()                
        tableView.backgroundColor = ColorScheme.leilaDesignGrey
        tableView.startActivityIndicator()
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(NewsViewController.refresh), for: .valueChanged)
        updateFunc()
        
        // remove cell borders
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    func updateFunc(){
        ArmadaApi.newsFromServer(){
            news, error, errorMessage in
            print(news)
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellIdentifier = ""
        if indexPath.row == 0 {
            cellIdentifier = "topWhiteCell"
        } else {
            cellIdentifier = news[indexPath.row].featured == true ? "largeWhiteCell" : "smallWhiteCell"
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NewsCell
        cell.newsItem = news[indexPath.row]
        return cell as! UITableViewCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        //ScrollNewsViewController,
        if let controller = segue.destination as? NewsArticleViewController,
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
