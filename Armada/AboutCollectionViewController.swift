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
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if(UIScreen.main.bounds.size.width <= 320){
            return CGSize(width: collectionView.contentSize.width, height: 228000/collectionView.contentSize.width + 120)
        }
        if(UIScreen.main.bounds.size.width <= 390){
            return CGSize(width: collectionView.contentSize.width, height: 262000/collectionView.contentSize.width + 120)
        }
       return CGSize(width: collectionView.contentSize.width, height: 242000/collectionView.contentSize.width + 120)
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
                let about = "<font size='4.5' style='font-family:Lato-Regular;’ line-height: '0.7'>THS Armada arranges Scandinavia's largest career fair at KTH Royal Institute of Technology. Every year, more than 12,000 of Sweden's top engineering and architectural students flock to visit the fair to meet their future employers.</font>"
                let diversity = "<font size = '4.5' style='font-family:Lato-Regular;’ line-height: '0.7'>We are an organization that truly believes in everyone's equal worth and right to equal opportunities. Our exclusive area at the fair is called <b>Diversity Room</b>."
                
                let sustainability = "<font size = '4.5' style='font-family:Lato-Regular;’ line-height: '0.7'>Our belief in a green future motivates us to continuously make improvements towards a more sustainable fair. THS Armada has been climate neutral since 2015. We have chosen to dedicate a specific area at the fair called <b>Green Room</b></font>"
                
                let quality = "<font size = '4.5' style='font-family:Lato-Regular;’ line-height: '0.7'>We put great emphasis on matchmaking the right students with the right companies. This is done by including a matchmaking algorithm on the website. We want to maximize the value from your THS Armada-participation.</font>"
                headerView.aboutText.attributedText =  about.attributedHtmlString
                headerView.aboutText.isScrollEnabled = false
                headerView.aboutText.textAlignment = NSTextAlignment.center
                headerView.coreValuesLabel.font = UIFont(name: "BebasNeueRegular", size: 20.0)
                headerView.diversityText.attributedText = diversity.attributedHtmlString
                headerView.diversityText.isScrollEnabled = false
                headerView.diversityText.textAlignment = NSTextAlignment.center
                headerView.sustainabilityText.attributedText = sustainability.attributedHtmlString
                headerView.sustainabilityText.isScrollEnabled = false
                headerView.sustainabilityText.textAlignment = NSTextAlignment.center
                headerView.qualityText.attributedText = quality.attributedHtmlString
                headerView.qualityText.textAlignment = NSTextAlignment.center
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

