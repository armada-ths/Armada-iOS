//
//  UIViewController+Armada.swift
//  Armada
//
//  Created by Adibbin Haider on 2018-09-24.
//  Copyright © 2018 THS Armada. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instance() -> Self {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.initialViewController()
    }
}
