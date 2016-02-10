//
//  Colors.swift
//  BygTyppr
//
//  Created by Joe Henke on 2/9/16.
//  Copyright © 2016 Joe Henke. All rights reserved.
//

import UIKit

let theme: [String: String] = [
  "name" : "indigo_pink",
  "primary" : "#3F51B5",
  "primary_dark" : "#303F9F",
  "primary_light" : "#C5CAE9",
  "accent" : "#FF4081",
  "primary_text" : "#212121",
  "secondary_text" : "#727272",
  "icons" : "#FFFFFF",
  "divider" : "#B6B6B6"
]

/**
 UIColor extensions for a consistent palette.
 */
extension UIColor {
  class func matPrimary() -> UIColor {
    return UIColor(hexString: theme["primary"]!)
  }
  class func matPrimaryDark() -> UIColor {
    return UIColor(hexString: theme["primary_dark"]!)
  }
  class func matPrimaryLight() -> UIColor {
    return UIColor(hexString: theme["primary_light"]!)
  }
  class func matAccent() -> UIColor {
    return UIColor(hexString: theme["accent"]!)
  }
  class func matPrimaryText() -> UIColor {
    return UIColor(hexString: theme["primary_text"]!)
  }
  class func matSecondaryText() -> UIColor {
    return UIColor(hexString: theme["secondary_text"]!)
  }
  class func matIcons() -> UIColor {
    return UIColor(hexString: theme["icons"]!)
  }
  class func matDivider() -> UIColor {
    return UIColor(hexString: theme["icons"]!)
  }
}



/* extension UIColor {
class func FirenzeRed() -> UIColor {
return UIColor(red: 132/255.0, green: 35/255.0, blue: 0/255.0, alpha: 1.0)
}
class func FirenzeLightRed() -> UIColor {
return UIColor(red: 174/255.0, green: 65/255.0, blue: 35/255.0, alpha: 1.0)
}
class func FirenzeOrange() -> UIColor {
return UIColor(red: 255/255.0, green: 166/255.0, blue: 51/255.0, alpha: 1.0)
}
class func FirenzeYellow() -> UIColor {
return UIColor(red: 255/255.0, green: 238/255.0, blue: 155/255.0, alpha: 1.0)
}
class func FirenzeGreen() -> UIColor {
return UIColor(red: 62/255.0, green: 124/255.0, blue: 91/255.0, alpha: 1.0)
}
class func FirenzeDarkGreen() -> UIColor {
return UIColor(red: 28/255.0, green: 56/255.0, blue: 40/255.0, alpha: 1.0)
}

} */



extension UIColor {
  convenience init(hexString:String) {
    self.init(
      red:   CGFloat( strtoul( String(Array(hexString.characters)[1...2]), nil, 16) ) / 255.0,
      green: CGFloat( strtoul( String(Array(hexString.characters)[3...4]), nil, 16) ) / 255.0,
      blue:  CGFloat( strtoul( String(Array(hexString.characters)[5...6]), nil, 16) ) / 255.0, alpha: 1.0 )
  }
}


