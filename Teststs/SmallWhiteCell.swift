//
//  SmallWhiteCell.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-19.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class SmallWhiteCell: UITableViewCell, NewsCell {

    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var greyW: NSLayoutConstraint!
    @IBOutlet weak var greyH: NSLayoutConstraint!
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var whiteH: NSLayoutConstraint!
    @IBOutlet weak var whiteW: NSLayoutConstraint!
    
    @IBOutlet weak var leftW: NSLayoutConstraint!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgH: NSLayoutConstraint!
    @IBOutlet weak var circleH: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleH: NSLayoutConstraint!
    
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateImgView: UIImageView!
    
    @IBOutlet weak var dateimgH: NSLayoutConstraint!
    @IBOutlet weak var dateimgW: NSLayoutConstraint!
    
    var newsItem: News? = nil{
        didSet{
            if let newsItem = newsItem{
                let designGrey = UIColor(red: 0xF8/255, green: 0xF7/255, blue: 0xF7/255, alpha: 1)
                let armadaDarkGreen = UIColor(red: 0x00/255, green: 0xD7/255, blue: 0x09/255, alpha: 0.5)
                let screenSize: CGRect = UIScreen.main.bounds
                let screenW = screenSize.size.width
                let screenH = screenSize.size.height

                let A:CGFloat = 5.5
                let B:CGFloat = 0.04
                let C:CGFloat = 1.1
                let D:CGFloat = 0.25
                
                // setup verticalGap; horizontalGap: depend on screensize
                let horizontalGap = screenW * B
                let verticalGap = horizontalGap * C

                
                // setup greyview: depend on screensize
                greyView.backgroundColor = designGrey
                greyH.constant = round(screenH / A)
                greyW.constant = screenW
                
                // setup whiteview: depend on greyview
                whiteView.layer.borderWidth = 0.5
                whiteH.constant = greyH.constant - 2 * verticalGap
                whiteW.constant = greyW.constant - 2 * horizontalGap
                
                // setup leftview: depend on whiteview
                leftW.constant = whiteW.constant * D
                
                // try to setup image
                imgH.constant = leftW.constant
                circleH.constant = leftW.constant
                
                do{
                    let url =  NSURL(string: newsItem.imageUrlSquare)
                    let data = try Data(contentsOf: url! as URL)
                    let tmpImage =  UIImage(data: data)
                    imgView.image = tmpImage
                }
                catch{}
                
                // setup title:
                titleLabel.text = newsItem.title        
                titleLabel.font = UIFont(name: "Lato-Bold", size: 14.0)
                titleH.constant = whiteH.constant / 2
                
                // setup date:
                dateLabel.text = newsItem.publishedDate.format("yyyy MMM dd")
                dateLabel.font = UIFont(name: "Lato-Bold", size: 14.0)
                
                // setup dateView:
                dateView.backgroundColor = .white
                
                // setup date img:
                dateImgView.image = #imageLiteral(resourceName: "dateBanner.png")
                dateImgView.alpha = 0.5
                
                
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
