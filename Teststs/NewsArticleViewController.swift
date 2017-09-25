//
//  NewsArticleViewController.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-25.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class NewsArticleViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var imageView: UIImageView!    
    @IBOutlet weak var upperborderView: UIView!
    
    @IBOutlet weak var upperH: NSLayoutConstraint!
    
    @IBOutlet weak var dateimgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ingressLabel: UILabel!
    
    @IBOutlet weak var whiteW: NSLayoutConstraint!
    @IBOutlet weak var imageH: NSLayoutConstraint!
    
    var news: News!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenW = screenSize.size.width
        let screenH = screenSize.size.height
        let A:CGFloat = 0.409577
        let B:CGFloat = 0.92
        let C:CGFloat = 0.445634
        let ratio:CGFloat = (9.0/15.0)
        
        // setup colors
        self.view.backgroundColor = ColorScheme.leilaDesignGrey
        contentView.backgroundColor = ColorScheme.leilaDesignGrey
        borderView.backgroundColor = ColorScheme.leilaDesignGrey
        //upperborderView.backgroundColor = ColorScheme.navbarBorderGrey
        
        // setup widths 
        whiteW.constant = screenW * B
        
        // setup image
        imageH.constant = whiteW.constant * ratio
        if imageView.image == nil {
            if news.imageUrlWide != "" {
                URLSession.shared.dataTask(with: NSURL(string: news.imageUrlWide)! as URL, completionHandler: {(data, response, error) -> Void in
                    if error != nil {
                        print(error ?? "error is nil in URLSession.shared.dataTask in NewsArticleViewController.swift")
                        return
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        let image = UIImage(data: data!)
                        self.imageView.image = image
                    })
                }).resume()
            }
        }
        
        // setup border
        upperborderView.backgroundColor = ColorScheme.navbarBorderGrey
        
        // setup date
        dateimgView.image = #imageLiteral(resourceName: "dateBanner.png")
        dateLabel.text = news.publishedDate.format("yyyy MMM dd")
        dateLabel.font = UIFont(name: "Lato-Bold", size: 14.0)
        
        // setup title
        titleLabel.text = news.title
        titleLabel.font = UIFont(name: "Lato-Bold", size: 16.0)

        // setup ingress
        ingressLabel.text = news.ingress
        ingressLabel.font = UIFont(name:"Lato-Bold", size: 17.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
