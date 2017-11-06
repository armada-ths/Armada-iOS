//
//  matchExhibitors.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-11-01.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.
//

import UIKit

class matchDetailExhibitor: UIViewController {
    // @IBOutlet var mapH: NSLayoutConstraint!
 //   @IBOutlet var jobTitleLabel: UILabel!
    
   // @IBOutlet var jobLabel: UILabel!
    @IBOutlet var mapWidth: NSLayoutConstraint!
    @IBOutlet var mapHeight: NSLayoutConstraint!
    @IBOutlet var webButton: UIButton!
    @IBOutlet var contentview: UIView!
    @IBOutlet var mapImage: UIImageView!
    @IBOutlet var aboutText: UITextView!
    
    @IBOutlet var headerW: NSLayoutConstraint!
    @IBOutlet var headerH: NSLayoutConstraint!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var coreIcon: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var borderview: UIView!
    @IBOutlet var whiteView: UIView!
    @IBOutlet var companyName: UILabel!
    var match: UILabel?
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet var matchLevel: UILabel!
    var company: Company!
    
    
    override func viewDidLoad() {
        matchLevel.text = match?.text
        if(company.localImage != nil){
            let image = company.localImage
            if(Float((image?.size.width)!) > Float((image?.size.height)!)){
                headerW.constant = 150
                headerH.constant = headerW.constant * ((image?.size.height)! / (image?.size.width)!)
            }
            else{
                headerH.constant = 150
                headerW.constant = headerH.constant * ((image?.size.width)! / (image?.size.height)!)
            }
            headerImageView.image = image
        }
        else{
            let image = company.image
            if(Float((image?.size.width)!) > Float((image?.size.height)!)){
                headerW.constant = 150
                headerH.constant = headerW.constant * ((image?.size.height)! / (image?.size.width)!)
            }
            else{
                headerH.constant = 150
                headerW.constant = headerH.constant * ((image?.size.width)! / (image?.size.height)!)
            }
            headerImageView.image = image
        }
        super.viewDidLoad()
        self.navigationController?.navigationBar.viewWithTag(1)?.isHidden = true
//        if (company.jobTypes.count == 0){
//            jobTitleLabel.removeFromSuperview()
//            jobLabel.removeFromSuperview()
//
//        }
//        else{
//            jobLabel.text = Array(company.jobTypes.map({$0.jobType})).sorted().joined(separator: "\n")
//            jobLabel.font=UIFont(name: "Lato-Regular", size: 14)
//        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationItem.backBarButtonItem?.title = "Back"
        navigationController?.navigationBar.tintColor = ColorScheme.armadaGreen
        aboutText.text = company.companyDescription.strippedFromHtmlString
        if company.companyDescription.isEmpty {
            aboutText.text = "To be announced"
        }
        companyName.text = company.name
        if(company.website == nil || company.website == ""){
            webButton.isHidden = true
        }
      
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        matchLevel.layer.cornerRadius = 30
        matchLevel.layer.masksToBounds = true
        if(company.likesEquality){
            backgroundView.backgroundColor = ColorScheme.diversityRed
            scrollView.backgroundColor = ColorScheme.diversityRed
            matchLevel.backgroundColor = ColorScheme.diversityRed
            companyName.textColor = ColorScheme.diversityRed
            coreIcon.image = #imageLiteral(resourceName: "div")
            webButton.setImage(#imageLiteral(resourceName: "redWeb"), for: .normal)
           // jobTitleLabel.textColor = ColorScheme.diversityRed
            
        }
        else if (company.likesEnvironment){
            backgroundView.backgroundColor = ColorScheme.sustainabilityGreen
            scrollView.backgroundColor = ColorScheme.sustainabilityGreen
            coreIcon.image = #imageLiteral(resourceName: "sus")
            matchLevel.backgroundColor = ColorScheme.sustainabilityGreen

            
            
        }
        else{
            backgroundView.backgroundColor = ColorScheme.armadaLicorice
            scrollView.backgroundColor = ColorScheme.armadaLicorice
            matchLevel.backgroundColor = ColorScheme.armadaLicorice

            
        }
        
        
        //parent?.title = company.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationLabel.text = company.locationDescription
        if(company.locationUrl == "" || company.locationUrl == "https://ais.armada.nu/static/missing.png"){
            self.mapImage.isHidden = true
            return
        }
        URLSession.shared.dataTask(with: URL(string: company.locationUrl)!, completionHandler: {(data, response, error) -> Void in
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                let width = image?.size.width
                let height = image?.size.height
                self.mapWidth.constant = 250
                self.mapHeight.constant = 250 * (height! / width!)
                self.mapImage.image = image
            })
        }).resume()
    }
    
    
    
    @IBAction func openWebsite(_ sender: Any) {
        if(UIApplication.shared.canOpenURL(URL(string: company.website)!)){
            UIApplication.shared.openURL(URL(string: company.website)!)
        }
    }
}


