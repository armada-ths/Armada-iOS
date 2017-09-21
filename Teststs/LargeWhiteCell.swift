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
    
    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var dateimgView: UIImageView!
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
                let B:CGFloat = 0.04
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
                
                // setup image
                do {
                    let url = NSURL(string: newsItem.imageUrlWide)
                    let data = try! Data(contentsOf: url! as URL)
                    let tmpImage = UIImage(data: data)
                    // adjust img height
                    let tmpImageH:CGFloat = (tmpImage?.size.height)!
                    let tmpImageW:CGFloat = (tmpImage?.size.width)!
                    let ratio:CGFloat = (tmpImageH/tmpImageW)
                    imgH.constant = holderW.constant * ratio
                    imgView.image = tmpImage
                } catch {
                    // adjust image height
                    let ratio:CGFloat = (9.0/15.0)
                    imgH.constant = holderW.constant * ratio
                }
                
                // setup title:
                titleLabel.text = newsItem.title            
                titleLabel.font = UIFont(name: "Lato-Bold", size: 16.0)
                
                // setup date:
                dateLabel.text = newsItem.publishedDate.format("yyyy MMM dd")
                dateLabel.font = UIFont(name: "Lato-Bold", size: 14.0)
                
                // setup dateView:
                dateView.backgroundColor = .white
                
                // setup date img:
                dateimgView.image = #imageLiteral(resourceName: "dateBanner.png")
                dateimgView.alpha = 0.5
                
                // resize cell height so that the area under the image has height 56
                greyH.constant = 56 + imgH.constant + 2 * verticalGap
                holderH.constant = 56 + imgH.constant
                
                
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
