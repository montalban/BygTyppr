//
//  DialView.swift
//  BygTyppr
//
//  Created by Joe Henke on 2/7/16.
//  Copyright © 2016 Joe Henke. All rights reserved.
//

import UIKit

/**
set value for pi (option-p character)
*/
let π = CGFloat(M_PI)

/**
 Dial View is a custom UIView. Needs some work to be more versatile.
 */



@IBDesignable class DialView: UIView {

  @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
  @IBInspectable var barColor: UIColor = UIColor.orangeColor()
  @IBInspectable var arcWidth: CGFloat = 45.0
  @IBInspectable var borderWidth: CGFloat = 5.0
  var endAngle: CGFloat = CGFloat(2*π)
  var startAngle: CGFloat = CGFloat(π)
  var dialCenter: CGPoint?
  
  /**
   endAngleOffset is a computed variable to update drawRect whenever this values is changed. 
   */
  var endAngleOffset: CGFloat = 0.0 {
    didSet {
      setNeedsDisplay()
    }
  }


  //*****************************************************************
  // MARK: - drawRect
  //*****************************************************************

  override func drawRect(rect: CGRect) {
    
    dialCenter = CGPoint(x: bounds.width/2, y: bounds.height/2)
    /**
     subtracting 1 to prevent hairline pixel showing through underneath outline
     */
    let radius: CGFloat = max(bounds.width, bounds.height) - 2
    
    /* dial path */
    let path = UIBezierPath(arcCenter: dialCenter!, radius: radius/2 - arcWidth/2,
      startAngle: startAngle, endAngle: (endAngle + endAngleOffset), clockwise: true)
    
    /**
    sets how wide the dial is
    */
    path.lineWidth = arcWidth
    barColor.setStroke()
    path.stroke()
    
    
    /* outline path */
    let outlineEndAngle = endAngle    
    let outlinePath = UIBezierPath(arcCenter: dialCenter!, radius: bounds.width/2 - borderWidth/2,
      startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true)
    
    outlinePath.addArcWithCenter(dialCenter!, radius: bounds.width/2 - arcWidth + borderWidth/2,
      startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)
    
    outlinePath.closePath()
    outlineColor.setStroke()
    outlinePath.lineWidth = borderWidth
    outlinePath.stroke()
  }
}


