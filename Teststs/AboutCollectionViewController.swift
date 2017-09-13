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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.red

        if dataSource.isEmpty {
            dataSource.refresh()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let designGrey = UIColor(red: 0xF8/255, green: 0xF7/255, blue: 0xF7/255, alpha: 0xFF)
        let sqWidth:CGFloat = collectionView.contentSize.width/2 - 20.0 - 8.0
        collectionView.backgroundColor = designGrey
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
            //1
            switch kind {
            //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 withReuseIdentifier: "AboutHeaderCollectionReusableView",
                                                                                 for: indexPath) as! AboutHeaderCollectionReusableView
                headerView.noticeLabel.text = "hardcoded content goes here"
                let designGrey = UIColor(red: 0xF8/255, green: 0xF7/255, blue: 0xF7/255, alpha: 0xFF)
                headerView.backgroundColor = designGrey
                return headerView
            default:
                //4
                assert(false, "Unexpected element kind")
            }
        }

        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let sponsor = self[indexPath]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "partnerCell", for: indexPath) as! PartnerCollectionViewCell
                cell.partnerImage.loadImageFromUrl(sponsor.imageUrl.absoluteString)
                // NOTE:
                // get image height:width ratio
                var ratio:CGFloat
                if let data = NSData(contentsOf: sponsor.imageUrl) {
                    let tmpImg = UIImage(data: data as Data)
                    let height = (tmpImg?.size.height)!
                    let width = (tmpImg?.size.width)!
                    ratio = height/width
                } else {
                    // use default ratio
                    ratio = 1.0
                }
                cell.imgHeightConstraint.constant = ratio * cell.frame.width - 2.0 - 5.0
                cell.imgWidthConstraint.constant = cell.frame.width - 2.0 - 5.0
            
                cell.layer.borderWidth = 1.0
            
                return cell
        }
    }
}

