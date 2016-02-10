//
//  Label.swift
//  BygTyppr
//
//  Created by Joe Henke on 2/9/16.
//  Copyright © 2016 Joe Henke. All rights reserved.
//

import UIKit


// citation: http://stackoverflow.com/questions/3476646/uilabel-text-margin

class Label: UILabel {
  override func drawTextInRect(rect: CGRect) {
    super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)))
  }
}