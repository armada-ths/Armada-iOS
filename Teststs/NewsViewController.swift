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
    var refreshControl: UIRefreshControl!

    
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    func refresh(sender:AnyObject)
    {
        updateFunc()
        refreshControl.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title for back button for cell-segues
        backBarButton.title = ""
        tableView.backgroundColor = ColorScheme.leilaDesignGrey
        tableView.startActivityIndicator()
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        updateFunc()
        
        // remove cell borders
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // fix header
        let frame = CGRect(x: 0,y: 0, width: 200, height: 100);
        let label = UILabel(frame: frame)
        let myMutableString = NSMutableAttributedString(
            string: "N E W S THS Armada 2017",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeue-Thin",
                size: 22.0)!])
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueRegular", size: 22.0), range:NSRange(location: 0, length: 8))
        label.textAlignment = .center
        label.attributedText = myMutableString
        self.navigationItem.titleView = label
        
        // setup header left logo
        var armadalogo:UIImage = #imageLiteral(resourceName: "armada_round_logo_green.png")
        let headerHeight:CGFloat = (self.navigationController?.navigationBar.frame.size.height)!
        let headerImgSize = headerHeight * 0.8
        
        // change size of armada logo
        let newSize = CGSize(width: headerImgSize, height: headerImgSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        armadalogo.draw(in: CGRect(x: 0, y: 0, width: headerImgSize, height: headerImgSize))
        let newarmadalogo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // add armada logo to header
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:newarmadalogo , style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        // change status bar background color
        let statusView = UIView(frame: CGRect(x:0, y:0, width: 500, height: 20))
        statusView.backgroundColor = .black
        self.navigationController?.view.addSubview(statusView)
    
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
        
        let cellIdentifier = news[indexPath.row].featured == true ? "topWhiteCell" : "smallWhiteCell"
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
