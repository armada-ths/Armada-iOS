//
//  IntrestCollectionViewCell.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-10-25.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.
//

import UIKit

class IntrestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var intrest: UILabel!    
    @IBOutlet var selectionButton: UIButton!
   // var rootInterst: Bool!
    @IBAction func changeButtonFont(_ sender: UIButton) {
        if(selectionButton.backgroundColor == ColorScheme.worldMatchGrey){
            intrest.font = UIFont(name: "Lato-Light", size: 20)
        }
        else{
            intrest.font = UIFont(name: "Lato-Regular", size: 20)
            
        }
    }
}
