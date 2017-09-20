//
//  SmallTableViewCell.swift
//  Armada
//
//  Created by Ola Roos on 22/05/17.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class SmallNewsTableViewCell: UITableViewCell, NewsCell {

    @IBOutlet weak var newsImageView: UIImageView!
    
    var newsItem: News? = nil{
        didSet{
            if let newsItem = newsItem{
//                titleLabel.text = newsItem.title
//                dateLabel.text = newsItem.publishedDate.format("dd MMMM")
//                newsImageView.loadImageFromUrl(newsItem.imageUrlSquare)
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
