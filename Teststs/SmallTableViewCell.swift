//
//  SmallTableViewCell.swift
//  Armada
//
//  Created by Ola Roos on 22/05/17.
//  Copyright © 2017 Sami Purmonen. All rights reserved.
//

import UIKit

class SmallTableViewCell: UITableViewCell, NewsCell {

    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    var newsItem: News? = nil{
        didSet{
            if let newsItem = newsItem{
                titleLabel.text = newsItem.title
                dateLabel.text = newsItem.publishedDate.readableString
                newsImageView.loadImageFromUrl("https://cdn.apk-cloud.com/detail/image/se.ths.kth.Aramda-w250.png")
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
