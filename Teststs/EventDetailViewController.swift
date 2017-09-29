//
//  EventDetailViewController.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-09-29.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var upperborderView: UIView!
    
    @IBOutlet weak var upperH: NSLayoutConstraint!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var whiteW: NSLayoutConstraint!
    @IBOutlet weak var imageH: NSLayoutConstraint!
    
    @IBOutlet weak var registerLabel: UILabel!
    
    var event: ArmadaEvent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerLabel.layer.masksToBounds = true
        registerLabel.layer.cornerRadius = 10
        registerLabel.text = event.signupStateString
        if event.signupState == .now {
            registerLabel.isEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.registerClicked))
            registerLabel.isUserInteractionEnabled = true
            registerLabel.addGestureRecognizer(tap)
        }
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenW = screenSize.size.width
        let screenH = screenSize.size.height
        let A:CGFloat = 0.409577
        let B:CGFloat = 0.92
        let C:CGFloat = 0.445634
        let ratio:CGFloat = (9.0/15.0)
        
        // fix header
        let frame = CGRect(x: 0,y: 13, width: 200, height: 30);
        let label = UILabel(frame: frame)
        let myMutableString = NSMutableAttributedString(
            string: "E V E N T S THS Armada 2017",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeue-Thin",
                size: 22.0)!])
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueRegular", size: 22.0), range:NSRange(location: 0, length: 12))
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
            if event.imageUrl != nil {
                URLSession.shared.dataTask(with: event.imageUrl!, completionHandler: {(data, response, error) -> Void in
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
//        dateLabel.text = news.publishedDate.format("dd MMM yyyy")
        var dateText = NSMutableAttributedString(string: event.startDate.format("EEEE") + " " + event.startDate.format("HH:mm") + "\n" + event.startDate.format("dd MMMM") + " " + (event.endDate?.format("HH:mm"))!,  attributes: [NSFontAttributeName:UIFont(
            name: "Lato-Regular",
            size: 14.0)])
        dateText.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Bold", size: 14.0), range:NSRange(location: 0, length: event.startDate.format("EEEE").characters.count))
        dateLabel.attributedText = dateText
        dateLabel.textColor = UIColor.white
        
        // setup title
        titleLabel.text = event.title
        titleLabel.font = UIFont(name: "BebasNeueRegular", size: 30.0)
        
        locationLabel.text = event.location
        locationLabel.font = UIFont(name: "Lato-Regular", size: 14.0)
        

        
        // setup text
        textView.delegate = self
        textView.attributedText = self.setFont(newsString: event.summary)

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
    
    
    @IBAction func registerClicked(_ sender: Any) {
        if let signupUrl = event.signupLink,
            let url = URL(string: signupUrl) {
            UIApplication.shared.openURL(url)
        }
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
