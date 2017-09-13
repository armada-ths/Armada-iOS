//
//  PartnerCollectionViewCell.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-05.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit

class PartnerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var partnerImage: UIImageView!
    // NOTE:
    // Add these constraints here otherwise we get error 
    // Outlets cannot be connected to repeating content iOS
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
}
