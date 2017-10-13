//
//  EventTableViewCell.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-10-12.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.
//

import UIKit
import CoreGraphics

class EventTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    var diff = 0
    // @IBOutlet weak var dateView: UIView!
    
 //   @IBOutlet weak var dateimgView: UIImageView!
    @IBOutlet weak var daysLeftLabel: UILabel!
    
    var eventItem: ArmadaEvent? = nil{
        didSet{
            if let eventItem = eventItem{
                let screenSize: CGRect = UIScreen.main.bounds
                
                if let viewWithTag = self.viewWithTag(100){
                    viewWithTag.removeFromSuperview()
                }
                if let viewWithTag = self.viewWithTag(101){
                    viewWithTag.removeFromSuperview()
                }
                // setup title:
                titleLabel.text = eventItem.title
                titleLabel.font = UIFont(name: "BebasNeueRegular", size: 40.0)
                titleLabel.textAlignment = NSTextAlignment.center
                
                // setup Days Left:
                let calendar = Calendar.current
                let date2 = calendar.startOfDay(for: eventItem.startDate)
                let date1 = calendar.startOfDay(for: Date())
                let start = calendar.ordinality(of: .day, in: .era, for: date1)!
                let end = calendar.ordinality(of: .day, in: .era, for: date2)!
                diff = end - start
               // daysLeftLabel.text
                var myMutableString: NSMutableAttributedString
                if(diff > 0){
                    myMutableString = NSMutableAttributedString(
                    string: "Days left" + "\n" + "\(diff)",
                    attributes: [NSFontAttributeName:UIFont(
                        name: "Lato-Regular",
                        size: 25.0)!])
                myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 15.0), range:NSRange(location: 0, length: 9))                    
                }
                
                else if (diff == 0){
                    myMutableString = NSMutableAttributedString(
                        string: "TODAY",
                        attributes: [NSFontAttributeName:UIFont(
                            name: "Lato-Regular",
                            size: 15.0)!])
                    
                }
                else{
                 myMutableString = NSMutableAttributedString(
                        string: "PASSED",
                        attributes: [NSFontAttributeName:UIFont(
                            name: "Lato-Regular",
                            size: 15.0)!])
                    let blurEffectView = UIView()
                    blurEffectView.backgroundColor = UIColor(patternImage: UIImage(named:"blurr")!)
                    blurEffectView.frame = self.bounds
                    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    blurEffectView.alpha = 0.5
                    blurEffectView.tag = 100
                    self.addSubview(blurEffectView)
                    let blurRound = UIView()
                    blurRound.backgroundColor = UIColor(patternImage: UIImage(named:"blurr")!)
                    blurRound.frame = daysLeftLabel.bounds
                    blurRound.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    blurRound.alpha = 0.5
                    blurRound.tag = 101
                    let start = CGFloat(0)
                    let end = start + CGFloat(M_PI)
                    let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: daysLeftLabel.bounds.size.width / 2, y: (daysLeftLabel.bounds.size.height / 2)), radius: daysLeftLabel.bounds.size.height, startAngle: start, endAngle: end, clockwise: true)
                    let circleShape = CAShapeLayer()
                    circleShape.path = circlePath.cgPath
                    blurRound.layer.mask = circleShape
                    daysLeftLabel.addSubview(blurRound)

                }
                daysLeftLabel.attributedText = myMutableString
                daysLeftLabel.textAlignment = NSTextAlignment.center
                daysLeftLabel.layer.cornerRadius = daysLeftLabel.frame.size.width/2
                daysLeftLabel.clipsToBounds = true
                daysLeftLabel.layer.shadowColor = UIColor.darkGray.cgColor
                daysLeftLabel.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
                daysLeftLabel.layer.shadowRadius = 1.0
                daysLeftLabel.layer.shadowOpacity = 0.7
                daysLeftLabel.layer.masksToBounds = true
                self.separatorInset = UIEdgeInsets.zero
                self.layoutMargins = UIEdgeInsets.zero
                shadowLayer.backgroundColor = UIColor.black
                shadowLayer.alpha = 0.25
                shadowLayer.layer.cornerRadius = shadowLayer.frame.size.width/2
                shadowLayer.bringSubview(toFront: daysLeftLabel)
                daysLeftLabel.layer.zPosition = 1
                //self.bringSubview(toFront: daysLeftLabel)
                
                
                //Setup Date
                let startDate = eventItem.startDate
                let endDate = eventItem.endDate
                let sMonth = calendar.component(.month, from: startDate)
                let sDay = calendar.component(.day, from: startDate)
                let eMonth = calendar.component(.month, from: endDate!)
                let eDay = calendar.component(.day, from: endDate!)
                
                var dateText: String
                if( (sMonth == eMonth && sDay == sDay) || endDate == nil){
                    dateText = startDate.format("dd MMMM YYYY")
                    
                }
                else{
                    dateText = startDate.format("dd-") + endDate!.format("dd MMMM YYYY")
                }


                dateLabel.text = dateText
                dateLabel.font = UIFont(name: "Lato-Regular", size: 14)
                dateLabel.frame = CGRect(x: 20, y: 20, width: 200, height: 200)

                dateLabel.sizeToFit()
                dateView.frame = CGRect(x: 20, y: 20, width: 200, height: 200)

                dateView.sizeToFit()
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
