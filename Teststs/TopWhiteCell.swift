//
//  TopWhiteCell.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-24.
//  Copyright © 2017 Sami Purmonen. All rights reserved.
//

import UIKit

class TopWhiteCell: UITableViewCell, NewsCell {

    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var greyW: NSLayoutConstraint!
    
    //@IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var whiteTop: NSLayoutConstraint!
    @IBOutlet weak var whiteBottom: NSLayoutConstraint!
    @IBOutlet weak var whiteLead: NSLayoutConstraint!
    @IBOutlet weak var whiteTrail: NSLayoutConstraint!
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var whiteW: NSLayoutConstraint!
    //@IBOutlet weak var whiteH: NSLayoutConstraint!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgH: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateimgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var ingressLabel: UILabel!
    
    var newsItem: News? = nil{
        didSet{
            if let newsItem = newsItem{
                let screenSize: CGRect = UIScreen.main.bounds
                let screenW = screenSize.size.width
                let screenH = screenSize.size.height
                
                let A:CGFloat = 0.409577
                let B:CGFloat = 0.92
                let C:CGFloat = 0.445634
                
                // setup greyview: depend on screensize
                greyView.backgroundColor = ColorScheme.leilaDesignGrey
                greyW.constant = screenW
                
                // setup borderview
                //borderView.backgroundColor = ColorScheme.navbarBorderGrey
                
                // setup whiteview
                //whiteH.constant = screenH * A
                whiteW.constant = screenW * B
                
                //whiteLead.constant = screenW - whiteW.constant/2.0
                //whiteTrail.constant = whiteLead.constant
                //whiteTop.constant = 10.0
                //whiteBottom.constant = 10.0
                
                // setup image
                let ratio:CGFloat = (9.0/15.0)
                imgH.constant = whiteW.constant * ratio
                
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
                
                // setup ingress:
                ingressLabel.text = newsItem.ingress
                ingressLabel.font = UIFont(name: "Lago-Bold", size: 14.0)
                
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
