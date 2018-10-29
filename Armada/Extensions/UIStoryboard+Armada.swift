//
//  UIStoryboard.swift
//  Armada
//
//  Created by Adibbin Haider on 2018-09-24.
//  Copyright © 2018 THS Armada. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func initialViewController<T: UIViewController>() -> T {
        return self.instantiateInitialViewController() as! T
    }
}
