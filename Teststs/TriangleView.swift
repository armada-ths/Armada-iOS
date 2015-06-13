//
//  TriangleView.swift
//  Teststs
//
//  Created by Sami Purmonen on 13/06/15.
//  Copyright © 2015 Sami Purmonen. All rights reserved.
//

import UIKit

@IBDesignable
class TriangleView: UIView {
    
    enum Direction {
        case Top, Right, Bottom, Left
    }
    
    
    @IBInspectable var name: String {
        get {
            return "Zebra"
        } set {
            
        }
    }
    
    @IBInspectable var direction: Direction {
        get {
            return .Top
        } set {
            
        }
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = UIColor.redColor()
//        let mask = CAShapeLayer()
//        let path = UIBezierPath()
//        path.moveToPoint(CGPoint(x: frame.width, y: frame.height))
//        path.addLineToPoint(CGPoint(x: frame.width, y: 0))
//        path.addLineToPoint(CGPoint(x: 0, y: frame.height))
//        path.addLineToPoint(CGPoint(x: frame.width, y: frame.height))
//        mask.path = path.CGPath
//        layer.mask = mask
//        backgroundColor = UIColor.redColor()
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }

//    override func prepareForInterfaceBuilder() {
//        backgroundColor = UIColor.redColor()
//        let mask = CAShapeLayer()
//        let path = UIBezierPath()
//        path.moveToPoint(CGPoint(x: frame.width, y: frame.height))
//        path.addLineToPoint(CGPoint(x: frame.width, y: 0))
//        path.addLineToPoint(CGPoint(x: 0, y: frame.height))
//        path.addLineToPoint(CGPoint(x: frame.width, y: frame.height))
//        mask.path = path.CGPath
//        layer.mask = mask
//        backgroundColor = UIColor.redColor()
//    }
    
    override func drawRect(rect: CGRect) {
        backgroundColor = UIColor.redColor()
        let mask = CAShapeLayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: frame.width, y: frame.height))
        path.addLineToPoint(CGPoint(x: frame.width, y: 0))
        path.addLineToPoint(CGPoint(x: 0, y: frame.height))
        path.addLineToPoint(CGPoint(x: frame.width, y: frame.height))
        mask.path = path.CGPath
        layer.mask = mask
    }

}
