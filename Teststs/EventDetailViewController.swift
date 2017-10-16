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
    
    @IBOutlet weak var eventPin: UIImageView!
    @IBOutlet weak var eventCalendar: UIImageView!
    
    //Waves
    //White wave
    @IBOutlet weak var wave100H: NSLayoutConstraint!
    @IBOutlet weak var waveImage100D: NSLayoutConstraint!
    @IBOutlet weak var waveImage100: UIImageView!

    
    ///Op 50 wave
    
    @IBOutlet weak var wave50: UIImageView!
    @IBOutlet weak var wave50H: NSLayoutConstraint!
    @IBOutlet weak var wave50D: NSLayoutConstraint!
    @IBOutlet weak var wave50W: NSLayoutConstraint!

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var titleLabelD: NSLayoutConstraint!
    @IBOutlet weak var whiteW: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageH: NSLayoutConstraint!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var event: ArmadaEvent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide img-logo temporarily
        self.navigationController?.navigationBar.viewWithTag(1)?.isHidden = true
        
        if event.signupState != .now {
            registerButton.isEnabled = false
            registerButton.isHidden = true
        }
        registerButton.layer.shadowColor = UIColor.black.cgColor
        registerButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        registerButton.layer.shadowRadius = 5
        registerButton.layer.shadowOpacity = 0.5
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenW = screenSize.size.width
        let screenH = screenSize.size.height
        let A:CGFloat = 0.409577
        let B:CGFloat = 0.92
        let C:CGFloat = 0.445634
        let ratio:CGFloat = (9.0/15.0)
        // set title if not set
        if self.navigationItem.titleView == nil {
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
        }

 
        // setup colors
        self.view.backgroundColor = ColorScheme.leilaDesignGrey
        contentView.backgroundColor = ColorScheme.leilaDesignGrey
        borderView.backgroundColor = ColorScheme.leilaDesignGrey
        upperborderView.backgroundColor = ColorScheme.navbarBorderGrey
        whiteView.backgroundColor = ColorScheme.leilaDesignGrey
        
        // setup widths
        whiteW.constant = screenW
        
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
        
        //Setup whitewave
        wave100H.constant = whiteW.constant/(1325/505) - 20
        waveImage100D.constant = 30 + imageH.constant - wave100H.constant
        
        //Setup wave with 50% opacity
        wave50H.constant = wave100H.constant - 5
        wave50D.constant = waveImage100D.constant


        
        // setup border
        upperborderView.backgroundColor = ColorScheme.navbarBorderGrey
        
        // setup colour of textView
        textView.backgroundColor = ColorScheme.leilaDesignGrey


        
        // setup title
        titleLabel.text = event.title
        titleLabel.font = UIFont(name: "BebasNeueRegular", size: 30.0)
        titleLabelD.constant = -(waveImage100D.constant/2.3)
        titleLabel.layer.zPosition = 1
        
        
        //Setup Date
        dateLabel.text = event.startDate.format("dd MMMM")
        dateLabel.font = UIFont(name: "Lato-Regular", size: 14)
        dateLabel.layer.zPosition = 1
        eventCalendar.layer.zPosition = 1

        //Setup Location
        locationLabel.text = event.location
        locationLabel.font = UIFont(name: "Lato-Regular", size: 14)
        locationLabel.layer.zPosition = 1
        eventPin.layer.zPosition = 1
        
        // setup text
        textView.delegate = self
        textView.attributedText = self.setFont(newsString: event.summary)
        textView.layer.zPosition = 1
        
        


    }
    
    func setFont(newsString: String) -> NSAttributedString{
        let newAttributedString = NSMutableAttributedString(string: newsString)
        // Enumerate through all the font ranges
        newAttributedString.enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, newAttributedString.length), options: []) { value, range, stop in
 
            guard let currentFont = value as? UIFont else {
                let newFont = UIFont(name: "Lato-Regular", size: 14)
                newAttributedString.addAttributes([NSFontAttributeName: newFont], range: range)
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
