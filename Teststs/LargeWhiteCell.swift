//
//  LargeWhiteCell.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-19.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class LargeWhiteCell: UITableViewCell, NewsCell {

    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var greyW: NSLayoutConstraint!
    @IBOutlet weak var greyH: NSLayoutConstraint!
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var holderW: NSLayoutConstraint!
    @IBOutlet weak var holderH: NSLayoutConstraint!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgH: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var newsItem: News? = nil{
        didSet{
            if let newsItem = newsItem{
                let designGrey = UIColor(red: 0xF8/255, green: 0xF7/255, blue: 0xF7/255, alpha: 1)
                let armadaDarkGreen = UIColor(red: 0x00/255, green: 0xD7/255, blue: 0x09/255, alpha: 0.5)
                let screenSize: CGRect = UIScreen.main.bounds
                let screenW = screenSize.size.width
                let screenH = screenSize.size.height
                
                let A:CGFloat = 2.4
                let B:CGFloat = 0.02
                let C:CGFloat = 1.1
                let D:CGFloat = 0.25
                
                // setup verticalGap; horizontalGap: depend on screensize
                let horizontalGap = screenW * B
                let verticalGap = horizontalGap

                // setup greyview: depend on screensize
                greyView.backgroundColor = designGrey
                greyH.constant = round(screenH / A)
                greyW.constant = screenW
                
                // setup holderview: depend on greyview
                holderView.layer.borderWidth = 0.5
                holderH.constant = greyH.constant - 2 * verticalGap
                holderW.constant = greyW.constant - 2 * horizontalGap
                
                // calculate ratio
                let url = NSURL(string: newsItem.imageUrlWide)
                let data = try! Data(contentsOf: url! as URL)
                // make catch statement here!
                let tmpImage = UIImage(data: data)
                
                let tmpImageH:CGFloat = (tmpImage?.size.height)!
                let tmpImageW:CGFloat = (tmpImage?.size.width)!
//                let ratio:CGFloat = (tmpImageH/tmpImageW)
                let ratio:CGFloat = (9.0/15.0)
                
                // setup image: depend on image width
                imgH.constant = holderW.constant * ratio
                imgView.image = tmpImage
                
                // setup title:
                titleLabel.text = newsItem.title

                // setup date:
                dateLabel.text = newsItem.publishedDate.format("yyyy MMM dd")
                dateLabel.backgroundColor = armadaDarkGreen
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
