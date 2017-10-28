//
//  RangeSliderTrackLayer.swift
//  SwiftRangeSlider
//
//  Created by Brian Corbin on 5/22/16.
//  Copyright © 2016 Caramel Apps. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSliderTrack: CALayer {
  weak var rangeSlider: RangeSlider?
//  // OLA ORIGINAL
//  override func draw(in ctx: CGContext) {
//    if let slider = rangeSlider {
//      // Clip
//      let cornerRadius = bounds.height * slider.curvaceousness / 2.0
//      let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//      ctx.addPath(path.cgPath)
//
//      // Fill the track
//      ctx.setFillColor(slider.trackTintColor.cgColor)
//      ctx.addPath(path.cgPath)
//      ctx.fillPath()
//
//      // Fill the highlighted range
//      ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
//      let lowerValuePosition = slider.positionForValue(slider.lowerValue).x
//      let upperValuePosition = slider.positionForValue(slider.upperValue).x
//      let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
//      ctx.fill(rect)
//    }
//  }
    // OLA ORIGINAL
    override func draw(in cty: CGContext) {
        if let slider = rangeSlider {
            // Clip
            let cornerRadius = bounds.height * slider.curvaceousness / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            cty.addPath(path.cgPath)
            
            // Fill the track
            cty.setFillColor(slider.trackTintColor.cgColor)
            cty.addPath(path.cgPath)
            cty.fillPath()
            
            // Fill the highlighted range
            cty.setFillColor(slider.trackHighlightTintColor.cgColor)
            let lowerValuePosition = slider.positionForValue(slider.lowerValue).y
            let upperValuePosition = slider.positionForValue(slider.upperValue).y
            let rect = CGRect(x: 0.0, y: lowerValuePosition, width: bounds.width, height: upperValuePosition - lowerValuePosition)
            cty.fill(rect)
        }
    }
}
