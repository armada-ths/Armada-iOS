//
//  ExhibitorTableViewCell.swift
//  Armada
//
//  Created by Adibbin Haider on 2018-09-22.
//  Copyright © 2018 THS Armada. All rights reserved.
//

import UIKit

class ExhibitorTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var logo: UIImageView!
    var path: String? {
        didSet {
            guard let path = self.path else { return }
            setImage(path: path)
        }

    }

    static var reuseIdentifier: String {
        return "ExhibitorTableViewCell"
    }

    func setImage(path: String) {
        let urlString = "https://ais.armada.nu" + path

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let imageData = data {
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.logo.image = image
                }
            }

        }).resume()
    }

}
