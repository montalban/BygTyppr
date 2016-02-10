//
//  SettingsVC.swift
//  BygTyppr
//
//  Created by Joe Henke on 2/9/16.
//  Copyright © 2016 Joe Henke. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
  
  @IBOutlet weak var backButton: UIBarButtonItem!
  
  @IBOutlet weak var defaultPercentage: UISegmentedControl!
  
  @IBAction func backButtonAction(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func saveDefaultPercentage(sender: AnyObject) {
    saveDefaultSettings()
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    let defaults = NSUserDefaults.standardUserDefaults()
    let defaultPercentageValue = defaults.integerForKey("defaultPercentage")
    defaultPercentage.selectedSegmentIndex = defaultPercentageValue
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func saveDefaultSettings() {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setInteger(defaultPercentage.selectedSegmentIndex, forKey: "defaultPercentage")
    defaults.synchronize() 
  }
   
}
