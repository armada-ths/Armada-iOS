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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationItem.backBarButtonItem?.title = "Back"
        navigationController?.navigationBar.tintColor = ColorScheme.armadaGreen
        aboutText.text = company.companyDescription.strippedFromHtmlString
        if company.companyDescription.isEmpty {
            aboutText.text = "To be announced"
        }
        companyName.text = company.name
      
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        matchLevel.layer.cornerRadius = 20
        matchLevel.layer.masksToBounds = true
        if(company.likesEquality){
            backgroundView.backgroundColor = ColorScheme.diversityRed
            scrollView.backgroundColor = ColorScheme.diversityRed
            matchLevel.backgroundColor = ColorScheme.diversityRed
            coreIcon.image = #imageLiteral(resourceName: "div")
            
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
                var ratio:CGFloat
                let image = UIImage(data: data!)
                self.mapImage.image = image
            })
        }).resume()
    }
    
    
    
    @IBAction func openWebsite(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: company.website)!)
        
    }
    
}


