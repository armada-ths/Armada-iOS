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
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var whiteW: NSLayoutConstraint!
    @IBOutlet weak var imageH: NSLayoutConstraint!
    
    var news: News!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide img-logo temporarily
        self.navigationController?.navigationBar.viewWithTag(1)?.isHidden = true

        let screenSize: CGRect = UIScreen.main.bounds
        let screenW = screenSize.size.width
        let screenH = screenSize.size.height
        let A:CGFloat = 0.409577
        let B:CGFloat = 0.92
        let C:CGFloat = 0.445634
        let ratio:CGFloat = (9.0/15.0)
        
        let frame = CGRect(x: 0,y: 13, width: 200, height: 30);
        let label = UILabel(frame: frame)
        let myMutableString = NSMutableAttributedString(
            string: "N E W S THS Armada 2017",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeue-Thin",
                size: 22.0)!])
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueRegular", size: 22.0), range:NSRange(location: 0, length: 8))
        label.textAlignment = .center
        label.attributedText = myMutableString
        let newTitleView = UIView(frame: CGRect(x: 0, y:0 , width: 200, height: 50))
        newTitleView.addSubview(label)
        self.navigationItem.titleView = newTitleView
        
        // setup colors
        self.view.backgroundColor = ColorScheme.leilaDesignGrey
        contentView.backgroundColor = ColorScheme.leilaDesignGrey
        borderView.backgroundColor = ColorScheme.navbarBorderGrey
        upperborderView.backgroundColor = ColorScheme.navbarBorderGrey
        
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
        dateLabel.text = news.publishedDate.format("dd MMM yyyy")
        dateLabel.font = UIFont(name: "Lato-Bold", size: 14.0)
        
        // setup title
        titleLabel.text = news.title
        titleLabel.font = UIFont(name: "BebasNeueRegular", size: 30.0)

        // setup ingress
        ingressLabel.text = news.ingress
        ingressLabel.font = UIFont(name:"Lato-Bold", size: 16.0)
        
        // setup text
        textView.delegate = self
        if (news.content == ""){
            ArmadaApi.newsContentFromServer(contentUrl: news.contentUrl) {
                content in
                DispatchQueue.main.async {
                    self.textView.attributedText = self.setFont(newsString: content)
                }
            }
        }
        else{
            textView.attributedText = setFont(newsString: news.content)
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
            // Here we describe the replacement font as coming from the "Lato" family
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
        paragraphStyle.lineSpacing = 3
        paragraphStyle.paragraphSpacing = 10
        newAttributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, newAttributedString.length))
        return newAttributedString
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
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
