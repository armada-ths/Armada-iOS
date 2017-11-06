//
//  IntrestCollectionViewCell.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-10-25.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.
//

import UIKit

class IntrestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var interest: UIButton!
    @IBOutlet var selectionButton: UIButton!
   // var rootInterst: Bool!
    @IBAction func changeButtonFont(_ sender: UIButton) {
        if(selectionButton.backgroundColor == ColorScheme.worldMatchGrey){
            interest.titleLabel?.font = UIFont(name: "Lato-Light", size: 19)
            selectionButton.backgroundColor = UIColor.white
            
        }
        else{
            interest.titleLabel?.font = UIFont(name: "Lato-Regular", size: 19)
            selectionButton.backgroundColor = ColorScheme.worldMatchGrey

            
        }
    }
}
