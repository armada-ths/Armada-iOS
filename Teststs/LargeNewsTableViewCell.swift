//
//  LargeNewsTableViewCell.swift
//  Armada
//
//  Created by Ola Roos on 22/05/17.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

protocol NewsCell {
    var newsItem:News? {get set};
}

class LargeNewsTableViewCell: UITableViewCell, NewsCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingressTextView: UITextView!
    @IBOutlet weak var ingressToDateCons: NSLayoutConstraint!

    
    @IBOutlet weak var dateLabel: UILabel!
    var newsItem: News? = nil{
        didSet{
            if let newsItem = newsItem{
                if (newsItem.ingress == "ingress property exists in database"){
                    //ingressTextView.text = newsItem.ingress
                    ingressTextView.text = "Om Nom Nom Nom..."
                } else {
                    ingressTextView.isSelectable = false
                    ingressTextView.isHidden = true
                    print(ingressTextView.frame.height)
                }
                titleLabel.text = newsItem.title
                dateLabel.text = newsItem.publishedDate.format("dd MMMM")
                newsImageView.loadImageFromUrl(newsItem.imageUrl)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
