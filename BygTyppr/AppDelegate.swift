//
//  AppDelegate.swift
//  BygTyppr
//
//  Created by Joe Henke on 2/5/16.
//  Copyright © 2016 Joe Henke. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }

 
}


extension UIView {
  
  /**
   UIView extension for adding a drop shadow
   - parameter radius: (default=4) blur filter radius
   - parameter offsetX: (default=5) offset in x-axis
   - parameter offsetY: (default=5) offset in y-axis
   - parameter opacity: (default=0.4) shadow opacity
   - parameter color: (default=black) UIColor shadow color
   */
  func dropShadow(radius radius: Int = 4, offsetX: CGFloat = 5, offsetY: CGFloat = 5,
    opacity: Float = 0.4, color: UIColor = UIColor.blackColor()) {
      let layer           = self.layer
      layer.shadowColor   = color.CGColor
      layer.shadowOffset  = CGSize(width: offsetX, height: offsetY)
      layer.shadowOpacity = opacity
      layer.shadowRadius  = CGFloat(radius)
  }
  
}




