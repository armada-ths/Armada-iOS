//
//  DetailedNewsTableViewController.swift
//  Armada
//
//  Created by Ola Roos on 30/05/17.
//

import UIKit

class DetailedNewsTableViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var news: News!
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        titleLabel.text = news.title
        dateLabel.text = news.publishedDate.formatWithStyle(.long)
        contentTextView.attributedText = news.content.attributedHtmlString ?? NSAttributedString(string: news.content)
    }
}
