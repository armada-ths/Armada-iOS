//
//  AboutViewController.swift
//  Teststs
//
//  Created by Sami Purmonen on 13/09/15.
//  Copyright © 2015 Sami Purmonen. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //aboutTextView.text = armadaPages["about_ths_armada"]??["app_text"] as? String
        aboutTextView.attributedText = (armadaPages["about_ths_armada"]??["app_text"] as? String)?.attributedHtmlString ?? NSAttributedString(string: (armadaPages["about_ths_armada"]??["app_text"] as? String) ?? "")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var aboutTextView: UITextView!

}
