//
//  ScrollTextViewController.swift
//  Armada
//
//  Created by Ola Roos on 02/06/17.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class ScrollNewsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollSubView: UIView!
    
    var newTopFrame: CGRect!
    var newScrollFrame: CGRect!



    var scale: CGFloat!
    var previousOffset: CGFloat!
    var defaultTopHeight: CGFloat!

    
    var news: News!

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var ingressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        newsImageView.loadImageFromUrl(news.imageUrlWide)
        titleLabel.text = news.title
        titleLabel.font = UIFont(name:"BebasNeueRegular", size: 35.0)
        ingressLabel.text = news.ingress
        ingressLabel.font = UIFont(name:"Lato-Bold", size: 20.0)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MMM YYY"
        dateLabel.text = dateFormat.string(from: news.publishedDate)
        dateLabel.font = UIFont(name:"Lato-Bold", size: 20.0)
        contentTextView.attributedText = news.content.attributedHtmlString ?? NSAttributedString(string: news.content)

        if (news.content == ""){
            ArmadaApi.newsContentFromServer(contentUrl: news.contentUrl) {
                content in
                DispatchQueue.main.sync {
                    self.contentTextView.attributedText = content.attributedHtmlString ?? NSAttributedString(string: content)                    
                }
            }
        }
        
    }
    
}

