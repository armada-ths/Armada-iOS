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
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var whiteH: NSLayoutConstraint!
    @IBOutlet weak var whiteW: NSLayoutConstraint!
    
    @IBOutlet weak var leftW: NSLayoutConstraint!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgW: NSLayoutConstraint!
    @IBOutlet weak var imgH: NSLayoutConstraint!
    
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var circleW: NSLayoutConstraint!
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
                let screenSize: CGRect = UIScreen.main.bounds
                let screenW = screenSize.size.width
                let screenH = screenSize.size.height

                let A:CGFloat = 0.92
                let B:CGFloat = 0.131934
                let C:CGFloat = 0.255072463768116
                let D:CGFloat = 0.16
                let E:CGFloat = 0.8
                
                // setup greyview: depend on screensize                
                greyView.backgroundColor = ColorScheme.leilaDesignGrey
                greyH.constant = screenH * D
                greyW.constant = screenW
                
                // setup borderview:
                borderView.backgroundColor = ColorScheme.navbarBorderGrey
                
                // setup whiteview: depend on greyview
                whiteW.constant = screenW * A
                whiteH.constant = screenH * B
                
                // setup leftview: depend on whiteview
                leftW.constant = whiteW.constant * C
                
                // try to setup image
                imgH.constant = leftW.constant * E
                imgW.constant = imgH.constant
                circleH.constant = imgH.constant
                circleW.constant = imgH.constant
                
                if newsItem.imageUrlSquare != "" {
                    URLSession.shared.dataTask(with: NSURL(string: newsItem.imageUrlSquare)! as URL, completionHandler: {(data, response, error) -> Void in
                        if error != nil {
                            print(error ?? "error is nil in URLSession.shared.dataTask in SmallWhiteCell.swift")
                            return
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            let image = UIImage(data: data!)
                            self.imgView.image = image
                            self.imgView.contentMode = .scaleAspectFill
                        })
                    }).resume()
                }
                
                else if newsItem.imageUrlWide != "" {
                    URLSession.shared.dataTask(with: NSURL(string: newsItem.imageUrlWide)! as URL, completionHandler: {(data, response, error) -> Void in
                        if error != nil {
                            print(error ?? "error is nil in URLSession.shared.dataTask in SmallWhiteCell.swift")
                            return
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            let image = UIImage(data: data!)
                            self.imgView.image = image
                        })
                    }).resume()
                }
                
                // setup title:
                titleLabel.text = newsItem.title        
                titleLabel.font = UIFont(name: "Lato-Bold", size: 14.0)
                titleH.constant = whiteH.constant / 2
                
                // setup date:
                dateLabel.text = newsItem.publishedDate.format("dd MMM yyyy")
                dateLabel.font = UIFont(name: "Lato-Bold", size: 14.0)
                
                // setup dateView:
                dateView.backgroundColor = .white
                
                // setup date img:
                dateImgView.image = #imageLiteral(resourceName: "dateBanner.png")
                dateImgView.alpha = 0.5
                
                // setup circle img:
                circleView.image = #imageLiteral(resourceName: "circle_compressed.png")
                
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
