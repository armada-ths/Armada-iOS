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
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var whiteW: NSLayoutConstraint!
    @IBOutlet weak var whiteH: NSLayoutConstraint!
    
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
                
                let A:CGFloat = 0.409577
                let B:CGFloat = 0.92
                let C:CGFloat = 0.445634
            
                // setup greyview: depend on screensize
                greyView.backgroundColor = designGrey
                greyH.constant = screenH * C
                greyW.constant = screenW
                
                // setup holderview: depend on greyview
                whiteView.layer.borderWidth = 0.5
                whiteH.constant = screenH * A
                whiteW.constant = screenW * B
                
                let ratio:CGFloat = (9.0/15.0)
                imgH.constant = whiteW.constant * ratio
                // setup image
                
                if imgView.image == nil {
                    if newsItem.imageUrlWide != "" {
                        URLSession.shared.dataTask(with: NSURL(string: newsItem.imageUrlWide)! as URL, completionHandler: {(data, response, error) -> Void in
                            if error != nil {
                                print(error ?? "error is nil in URLSession.shared.dataTask in LargeWhiteCell.swift")
                                return
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                let image = UIImage(data: data!)
                                self.imgView.image = image
                                print("img ratio\((self.imgView.image?.size.height)!/(self.imgView.image?.size.width)!)")
                                print("once again")
                            })
                        }).resume()
                    }
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
