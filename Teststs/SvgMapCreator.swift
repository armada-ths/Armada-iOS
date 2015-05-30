//
//  SvgMapCreator.swift
//  Teststs
//
//  Created by Paul Griffin on 30/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit

class SvgMapCreator: NSObject {
    func getMapForContinents()->UIImage{
        let path = NSBundle.mainBundle().pathForResource("BlankMap-World5", ofType: "png")
        let url = NSURL(string: path!)
        let data = NSData(contentsOfURL: url!)
        var xml = NSXMLParser(data: data!)
        var error:NSError?
        var stringData = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: &error)
        println(stringData)
        println(error)
        
        return UIImage()
    }
}
