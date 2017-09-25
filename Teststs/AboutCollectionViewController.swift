//
//  AboutCollectionViewController.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-05.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit
// UICollectionViewDelegateFlowLayout add to handle custom cell size

class AboutCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet var aboutView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if dataSource.isEmpty {
            dataSource.refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup datasource = SponsorCollectionViewDataSource
        dataSource = ArmadaSponsorCollectionViewDataSource(collectionViewController: self)
        collectionView?.dataSource = dataSource
        
        // setup header title
        let frame = CGRect(x: 0,y: 0, width: 200, height: 100);
        let label = UILabel(frame: frame)
        let myMutableString = NSMutableAttributedString(
            string: "A B O U T THS Armada 2017",
            attributes: [NSFontAttributeName:UIFont(
                name: "BebasNeue-Thin",
                size: 22.0)!])
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "BebasNeueRegular", size: 22.0), range:NSRange(location: 0, length: 9))
        label.textAlignment = .center
        label.attributedText = myMutableString
        self.navigationItem.titleView = label
        
        // setup header left logo
        var armadalogo:UIImage = #imageLiteral(resourceName: "armada_round_logo_green.png")
        let headerHeight:CGFloat = (self.navigationController?.navigationBar.frame.size.height)!
        let headerImgSize = headerHeight * 0.8
        let newSize = CGSize(width: headerImgSize, height: headerImgSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        armadalogo.draw(in: CGRect(x: 0, y: 0, width: headerImgSize, height: headerImgSize))
        let newarmadalogo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // setup header bottom border        
        let bottomBorderH:CGFloat = 0.75
        let bottomBorderRect = CGRect(x: 0, y: headerHeight, width: UIScreen.main.bounds.width, height: bottomBorderH)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = ColorScheme.navbarBorderGrey
        self.navigationController?.navigationBar.addSubview(bottomBorderView)
        
        // add armada logo to header
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:newarmadalogo , style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        // change status bar background color
        let statusGrey = UIColor(hex: 0x999A99)
        let statusView = UIView(frame: CGRect(x:0, y:0, width: 500, height: 20))
        statusView.backgroundColor = .black
        self.navigationController?.view.addSubview(statusView)

    }

    // DELEGATE methods:
    
    // NOTE:
    // Adding this function to customize the size of the cells depending on the size of the phone used
    
    // To use this solution, we need to set cell property to
    // custom in storyboard
    
    // Also, this is a delegate function so don't put it in the DataSource class below or it wont work :[
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // NOTE:
        // The left inset and right inset is set to 20 pixels in Storyboard.
        let sqWidth:CGFloat = collectionView.contentSize.width/3 - 20.0 - 8.0
        return CGSize(width: sqWidth, height: sqWidth);
    }
    
    
    
    // DATASOURCE:
    var dataSource: ArmadaSponsorCollectionViewDataSource!
    class ArmadaSponsorCollectionViewDataSource: ArmadaCollectionViewDataSource<Sponsor> {
        
        
        // NOTE:
        // Override this function to tweak handling of the Sponsor data.
        override func updateFunc(_ callback: @escaping (Response<[[Sponsor]]>) -> Void) {
            ArmadaApi.sponsorsFromServer { response in
                OperationQueue.main.addOperation {
                    callback( response.map {sponsors in
                        return [sponsors.filter {$0.isMainPartner || !$0.isMainPartner}]
                    })
                    OperationQueue().addOperation {
                        Thread.sleep(forTimeInterval: 0.2)
                        OperationQueue.main.addOperation {
                            self.collectionViewController?.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
        
        // NOTE:
        // this method deques the header view
        override func collectionView(_ collectionView: UICollectionView,
                                     viewForSupplementaryElementOfKind kind: String,
                                     at indexPath: IndexPath) -> UICollectionReusableView {
            print("running function for UICollectionReusableView")

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 withReuseIdentifier: "AboutHeaderCollectionReusableView",
                                                                                 for: indexPath) as! AboutHeaderCollectionReusableView
                let about = "<font size='4.5' style='font-family:Lato-Regular;’ line-height: '0.7'><b>Started in 1981,</b> THS Armada is a part of the student union THS and the largest student driven project at KTH The Royal Institute of Technology. The fair was first organised in 1981 and has been a recurring event at KTH ever since. The project has a turnover of more than 6 million SEK and involves more than 300 students.\n\n<b>Aside from the fair</b>, THS Armada has several other events, all to give you the best possible chance of finding your <i>dream</i> employer.</font>"
                let diversity = "<font size = '4.5' style='font-family:Lato-Regular;’ line-height: '0.7'>Exhibitors with this icon have expressed a focus on <b>diversity</b> in their organization and/or business and operations.</font>" //Events with this icon will be focused on topics regarding diversity.
                
                let sustainability = "<font size = '4.5' style='font-family:Lato-Regular;’ line-height: '0.7'>Exhibitors with this icon have expressed a focus on <b>sustainability</b> in their organization and/or business and operations.</font>"
               // Events with this icon will be focused on topics regarding sustainability."
                
                let quality = "<font size = '4.5' style='font-family:Lato-Regular;’ line-height: '0.7'>Exhibitors with this icon have expressed a focus on <b>quality</b> in their organization and/or business and operations.</font>"
                //Events with this icon will be focused on topics regarding quality."
                headerView.aboutText.attributedText =  about.attributedHtmlString
                headerView.aboutText.isScrollEnabled = false
                headerView.coreValuesLabel.font = UIFont(name: "BebasNeueRegular", size: 20.0)
                headerView.diversityText.attributedText = diversity.attributedHtmlString
                headerView.diversityText.isScrollEnabled = false
                headerView.sustainabilityText.attributedText = sustainability.attributedHtmlString
                headerView.sustainabilityText.isScrollEnabled = false
                headerView.qualityText.attributedText = quality.attributedHtmlString
                headerView.qualityText.isScrollEnabled = false
                headerView.partnersLabel.font = UIFont(name: "BebasNeueRegular", size: 20.0)
                return headerView
        }
        
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let sponsor = self[indexPath]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "partnerCell", for: indexPath) as! PartnerCollectionViewCell
           // cell.partnerImage.loadImageFromUrl(sponsor.imageUrl.absoluteString)
            // NOTE:
            // get image height:width ratio
            URLSession.shared.dataTask(with: sponsor.imageUrl, completionHandler: {(data, response, error) -> Void in
                        var ratio:CGFloat
                        if error != nil {
                            print(error ?? "error is nil in URLSession.shared.dataTask in PartnersCell.swift")
                            ratio = 1.0
                            cell.imgHeightConstraint.constant = ratio * cell.frame.width - 2.0 - 5.0
                            cell.imgWidthConstraint.constant = cell.frame.width - 2.0 - 5.0
                            return
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            var ratio:CGFloat
                            let image = UIImage(data: data!)
                            cell.partnerImage.image = image
                            let height = (image?.size.height)!
                            let width = (image?.size.width)!
                            ratio = height/width
                            cell.imgHeightConstraint.constant = ratio * cell.frame.width - 2.0 - 5.0
                            cell.imgWidthConstraint.constant = cell.frame.width - 2.0 - 5.0
                        })
                    }).resume()

            return cell
        }
        
    }
}

