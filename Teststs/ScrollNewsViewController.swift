//
//  ScrollTextViewController.swift
//  Armada
//
//  Created by Ola Roos on 02/06/17.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class ScrollNewsViewController: UIViewController, UITextViewDelegate {
        
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollSubView: UIView!
    
    @IBOutlet weak var scrollsubViewW: NSLayoutConstraint!

    var newTopFrame: CGRect!
    var newScrollFrame: CGRect!
    var scale: CGFloat!
    var previousOffset: CGFloat!
    var defaultTopHeight: CGFloat!
    var news: News!

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var ingressLabel: UILabel!
    
    @IBOutlet weak var newsImgW: NSLayoutConstraint!
    @IBOutlet weak var newsImgH: NSLayoutConstraint!
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        contentTextView.delegate = self
        
        let designGrey = UIColor(red: 0xF8/255, green: 0xF7/255, blue: 0xF7/255, alpha: 1)
        // fix header
        let frame = CGRect(x: 0,y: 0, width: 200, height: 100);
        let label = UILabel(frame: frame)
        let myMutableString = NSMutableAttributedString(
            string: "N E W S THS Armada 2017",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeue-Thin",
                size: 22.0)!])
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueRegular", size: 22.0), range:NSRange(location: 0, length: 8))
        label.textAlignment = .center
        label.attributedText = myMutableString
        self.navigationItem.titleView = label
        self.navigationItem.backBarButtonItem?.title = ""
        
        // setup ScrollView
        scrollView.backgroundColor = designGrey
        
        // setup image-width
        newsImgW.constant = UIScreen.main.bounds.size.width - 2 * 8.0
        newsImgH.constant = newsImgW.constant * 0.6
        // setup scrollSubView
        scrollsubViewW.constant = newsImgW.constant
        scrollSubView.backgroundColor = .white
        scrollSubView.layer.borderWidth = 0.5
        
        titleLabel.text = news.title
        titleLabel.font = UIFont(name:"BebasNeueRegular", size: 30.0)
        //titleLabel.textColor = ColorScheme.armadaGreen
        ingressLabel.text = news.ingress
        ingressLabel.font = UIFont(name:"Lato-Bold", size: 17.0)
        dateLabel.text = news.publishedDate.format("yyyy MMM dd")
        dateLabel.font = UIFont(name:"Lato-Bold", size: 17.0)
        
        if newsImageView.image == nil {
            if news.imageUrlWide != "" {
                URLSession.shared.dataTask(with: NSURL(string: news.imageUrlWide)! as URL, completionHandler: {(data, response, error) -> Void in
                    if error != nil {
                        print(error ?? "error is nil in URLSession.shared.dataTask in LargeWhiteCell.swift")
                        return
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        let image = UIImage(data: data!)
                        self.newsImageView.image = image
                        let ratio:CGFloat = (image!.size.height/image!.size.width)
                        self.newsImgH.constant = ratio * self.newsImgW.constant
                        self.newsImageView.layer.borderWidth = 0.5
                    })
                }).resume()
            }
        }
        
        if (news.content == ""){
            ArmadaApi.newsContentFromServer(contentUrl: news.contentUrl) {
                content in
                //DispatchQueue.main.sync {
                DispatchQueue.main.async {
                    self.contentTextView.attributedText = self.setFont(newsString: content)
                }
            }
        }
        else{
            contentTextView.attributedText = setFont(newsString: news.content)
        }
    }
    func setFont(newsString: String) -> NSAttributedString{
        let newAttributedString = NSMutableAttributedString(attributedString: newsString.attributedHtmlString!)
        // Enumerate through all the font ranges
        newAttributedString.enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, newAttributedString.length), options: []) { value, range, stop in
            guard let currentFont = value as? UIFont else {
                return
            }
            
            // An NSFontDescriptor describes the attributes of a font: family name, face name, point size, etc.
            // Here we describe the replacement font as coming from the "Hoefler Text" family
            let fontDescriptor = currentFont.fontDescriptor.addingAttributes([UIFontDescriptorFamilyAttribute: "Lato"])
            
            // Ask the OS for an actual font that most closely matches the description above


            if let newFontDescriptor = fontDescriptor.matchingFontDescriptors(withMandatoryKeys: [UIFontDescriptorFamilyAttribute]).first {
                let newFont = UIFont(descriptor: newFontDescriptor, size: currentFont.pointSize*0.8)
                newAttributedString.addAttributes([NSFontAttributeName: newFont], range: range)
            }
            else{
                let newFont = UIFont(name: "Lato-Regular", size: currentFont.pointSize*0.8)
                newAttributedString.addAttributes([NSFontAttributeName: newFont], range: range)
            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3 // Whatever line spacing you want in points
        newAttributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, newAttributedString.length))
        return newAttributedString
    }
    
}

