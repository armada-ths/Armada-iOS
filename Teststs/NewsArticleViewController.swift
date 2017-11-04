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
        
        // set title if not set
        if self.navigationItem.titleView == nil {
//            let frame = CGRect(x: 0,y: 13, width: 200, height: 30);
            let frame = CGRect(x: 0,y: 9, width: 200, height: 30);
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
        }
        
        // setup colors
//        self.view.backgroundColor = ColorScheme.leilaDesignGrey
//        contentView.backgroundColor = ColorScheme.leilaDesignGrey
//        borderView.backgroundColor = ColorScheme.navbarBorderGrey
//        upperborderView.backgroundColor = ColorScheme.navbarBorderGrey
        self.view.backgroundColor = ColorScheme.darkGrey
        contentView.backgroundColor = ColorScheme.darkGrey
        borderView.backgroundColor = ColorScheme.darkGrey
        upperborderView.backgroundColor = ColorScheme.darkGrey
        
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
                    self.setArticle(newsString: content)
                }
            }
        }
        else{
            textView.attributedText = setFont(newsString: news.content)
            setArticle(newsString: news.content)
            
        }
    }
    
    func setFont(newsString: String) -> NSAttributedString{
        let newsString = newsString.replacingOccurrences(of: "<p><img[^>]+></p>", with: "", options: String.CompareOptions.regularExpression, range: nil)
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
    
    func setArticle(newsString: String){
        DispatchQueue.main.async {
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
                if(String(describing: value).contains("bold")){
                    let newFont = UIFont(name: "Lato-Bold", size: currentFont.pointSize*0.8)
                    newAttributedString.addAttributes([NSFontAttributeName: newFont], range: range)
                    
                }
            
                else if let newFontDescriptor = fontDescriptor.matchingFontDescriptors(withMandatoryKeys: [UIFontDescriptorFamilyAttribute]).first {
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

            newAttributedString.enumerateAttribute(NSAttachmentAttributeName, in: NSMakeRange(0, newAttributedString.length), options: .init(rawValue: 0), using: { (value, range, stop) in
                if let attachement = value as? NSTextAttachment {
                    let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                    let screenSize: CGRect = UIScreen.main.bounds
                    if image.size.width > screenSize.width-50 {
                        let resizedImage = self.resizeImage(image: image, targetSize: CGSize(width: screenSize.width - 50, height: (screenSize.width - 50)*(image.size.height/image.size.width)))
                        let newAttribut = NSTextAttachment()
                        newAttribut.image = resizedImage
                        newAttributedString.addAttribute(NSAttachmentAttributeName, value: newAttribut, range: range)
                    }
                }
            })
            self.textView.attributedText = newAttributedString
        }
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
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool{
        return false
    }
}
