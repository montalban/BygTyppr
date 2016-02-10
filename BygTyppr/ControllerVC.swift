//
//  ControllerVC.swift
//  BygTyppr
//
//  Created by Joe Henke on 2/5/16.
//  Copyright © 2016 Joe Henke. All rights reserved.
//

import UIKit

class ControllerVC: UIViewController {
  
  
//*****************************************************************
// MARK: - Outlets, Actions, Properties
//*****************************************************************

  
  let tipPercentages: [Double] = [0.18, 0.22, 0.25]
  var billAmount: Double = 0
  let upperLayoutGuide: CGFloat = 100
  let lowerLayoutGuide: CGFloat = 180

  
  /* prevent non-numeric characters from being entered */
  let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet

  @IBOutlet weak var billField: UITextField!
  @IBOutlet weak var tipAmount: UILabel!
  @IBOutlet weak var totalAmount: UILabel!
  @IBOutlet weak var billLabel: UILabel!
  
  @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var tipPercentage: UISegmentedControl!
  @IBOutlet weak var dialView: DialView!
  @IBOutlet weak var needleView: UIView!
  @IBOutlet weak var panView: UIView!
  
  @IBOutlet weak var youPayLabel: UILabel!
  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var tipTextLabel: UILabel!
  
  
  @IBAction func billFieldAction(sender: AnyObject) {
    calculateTip()
  }

  /* tapping outside the textfield updates values and resigns first responder */
  @IBAction func onTap(sender: AnyObject) {
    calculateTip()
    animateInputViewTo(upperLayoutGuide)
    dialViewVisible()
    billField.resignFirstResponder()
  }

//*****************************************************************
// MARK: - View Methods
//*****************************************************************

  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* make view delegate of textField */
    billField.delegate = self
    billField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let defaultPercentageValue = defaults.integerForKey("defaultPercentage")
    tipPercentage.selectedSegmentIndex = defaultPercentageValue

    /* set the intial positio of the stack view */
    stackViewTopConstraint.constant = lowerLayoutGuide
    
    /* add pan gesture recognizer */
    let panGesture = UIPanGestureRecognizer()
    panGesture.addTarget(self, action: "panningOnDial:")
    panView.userInteractionEnabled = true
    panView.addGestureRecognizer(panGesture)
    
    /* run convenience methods */
    calculateTip()
    configureUI()
    dialViewInvisible()
  }
  
  override func viewWillAppear(animated: Bool) {
    let defaults = NSUserDefaults.standardUserDefaults()
    let defaultPercentageValue = defaults.integerForKey("defaultPercentage")
    tipPercentage.selectedSegmentIndex = defaultPercentageValue
    calculateTip()
  }
  
//*****************************************************************
// MARK: - pan Gesture Method
//*****************************************************************

  /**
  action for panning on dial.
  calculates angle for needle and value.
  angle must lie between starting angle and ending angle.
  */
  func panningOnDial(sender:UIPanGestureRecognizer) -> Void {
    self.view!.bringSubviewToFront(sender.view!)
    var location: CGPoint?
    var angle: CGFloat = 0.0
    if sender.state != .Ended && sender.state != .Failed {
      location = sender.locationInView(panView)
      angle = getAngle(dialView.dialCenter!, toPoint: location!) + dialView.startAngle
      if angle > dialView.startAngle && angle < dialView.endAngle {
        dialView.endAngleOffset = angle - dialView.endAngle
        needleView.transform = CGAffineTransformMakeRotation(angle + dialView.startAngle/2)
        let perc = getDialTipPercentage(angle)
        calculateTip(Double(perc))
      }
    }
  }
  
  
}


//*****************************************************************
// MARK: - Configure UI
//*****************************************************************

extension ControllerVC {
  
  /**
   convenience method for hiding thing and setting up UI
   */
  func configureUI() {
    dialView.backgroundColor = UIColor.clearColor()
    self.tipAmount.alpha = 0
    self.totalAmount.alpha = 0
    self.tipPercentage.alpha = 0
    self.youPayLabel.alpha = 0
    self.tipLabel.alpha = 0
  }
  
  /**
   convenience method for fading on and moving the view into position for calculating tip
   */
  func animateInputViewTo(amount: CGFloat) {
    stackViewTopConstraint.constant = amount
    UIView.animateWithDuration(0.25) {
      self.view.layoutIfNeeded()
     }
  }
  
  /**
   convenience for hiding dialView
   */
  func dialViewInvisible() {
    dialView.userInteractionEnabled = false
    dialView.hidden = true
    self.tipTextLabel.hidden = true
    
    UIView.animateWithDuration(0.15) { () -> Void in
      self.tipAmount.alpha = 0
      self.totalAmount.alpha = 0
      self.tipPercentage.alpha = 0
      self.youPayLabel.alpha = 0
      self.tipLabel.alpha = 0
      self.dialView.alpha = 0
      self.tipTextLabel.alpha = 0
    }

  }
  
  /**
   convenience for fading on dialView
   */
  func dialViewVisible() {
    dialView.userInteractionEnabled = true
    dialView.alpha = 0
    dialView.hidden = false
    tipTextLabel.alpha = 0
    tipTextLabel.hidden = false
    UIView.animateWithDuration(0.5) { () -> Void in
      self.tipAmount.alpha = 1
      self.totalAmount.alpha = 1
      self.tipPercentage.alpha = 1
      self.youPayLabel.alpha = 1
      self.tipLabel.alpha = 1
      self.dialView.alpha = 1
      self.tipTextLabel.alpha = 1
    }
  }

}

//*****************************************************************
// MARK: - textField Delegate methods
//*****************************************************************

extension ControllerVC : UITextFieldDelegate {

  /**
   view fades on and moves into place after entering bill amount
   */
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if let text = billField.text {
      if text != "" {
        billAmount = Double(text)!
        calculateTip()
        animateInputViewTo(upperLayoutGuide)
        dialViewVisible()
      }
    }
    textField.resignFirstResponder()
    return true;
  }
  
  /**
   clear the textfield for entering bill
   */
  func textFieldDidBeginEditing(textField: UITextField) {
    billLabel.text = "$"
    billField.text = ""
    billAmount = 0
    calculateTip()
    dialViewInvisible()
    animateInputViewTo(lowerLayoutGuide)
  }
  
  /**
   update tip calculate as each character is entered
   checks to make sure methods and formating have values
   */
  func textFieldDidChange(textField: UITextField) {
    if let text = billField.text {
      if text != "" {
        billAmount = (Double(text)!/1)
        billLabel.text = formatDollars(billAmount)
        calculateTip()
      }
    } else {
      textField.resignFirstResponder()
    }
  }
  
}


//*****************************************************************
// MARK: - Convenience Methods
//*****************************************************************

extension ControllerVC {
  
  /**
   convenience method for calculating tip
   */
  func calculateTip() {
    let bill = Double(billAmount)
    let tip = self.tipPercentages[tipPercentage.selectedSegmentIndex]
    updateDial(CGFloat(tip))
    let total = bill + (bill * tip)
    let tipText = String(Int(tip * 100)) + "%"
    self.tipTextLabel.text = tipText
    tipAmount.text = formatDollars(total - bill)
    totalAmount.text = formatDollars(total)
  }
  
  func calculateTip(tip: Double) {
    let bill = Double(billAmount)
    let total = bill + (bill * tip)
    tipAmount.text = formatDollars(total - bill)
    totalAmount.text = formatDollars(total)
    let tipText = String(Int(tip * 100)) + "%"
    self.tipTextLabel.text = tipText
  }
  
  /**
   returns the parameter from the needle for calculating the actual tip
   */
  func getDialTipPercentage(dialValue: CGFloat) -> CGFloat {
    let tipRange = CGFloat(tipPercentages.last! - tipPercentages.first!)
    let dialRange = dialView.endAngle - dialView.startAngle
    let tipPercentage = ((dialValue - dialView.startAngle) / dialRange) * tipRange + CGFloat(tipPercentages.first!)
    return tipPercentage
  }
  
  /**
   update the Dial based on tip amount (from choosing tip percentage on segmented controller)
   */
  func updateDial( tip: CGFloat) -> Void {
    let tipStart = CGFloat(tipPercentages.first!)
    let tipEnd = CGFloat(tipPercentages.last!)
    let tipRange = tipEnd - tipStart
    let dialRange = dialView.endAngle - dialView.startAngle
    let dialPercentage = (tip-tipStart)/tipRange
    let offset = dialPercentage * dialRange
    dialView.endAngleOffset = offset - dialView.startAngle
    needleView.transform = CGAffineTransformMakeRotation(offset - dialView.startAngle/2)
  }
  
  /**
   returns the interior angle from two positions
   */
  func getAngle(fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat {
    let dx: CGFloat = fromPoint.x - toPoint.x
    let dy: CGFloat = fromPoint.y - toPoint.y
    let radians: CGFloat = atan2(dy, dx)
    return radians
  }

  /**
   prettify string to look like currency. Adds dollar signs and commas.
   */
  func formatDollars(amount: Double) -> String {
    let amountString = String(amount)
    var dollars: NSNumber = 0
    if let number = NSNumberFormatter().numberFromString(amountString) {
      dollars = number
    }
    let dollarFormatter = NSNumberFormatter()
    dollarFormatter.locale =  NSLocale(localeIdentifier: "en_US")
    dollarFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
    dollarFormatter.currencyCode = "USD"
    dollarFormatter.maximumFractionDigits = 2
    let newDollars = Double(dollars)/100
    let newnewDollars = NSNumber(double: newDollars)
    return dollarFormatter.stringFromNumber(newnewDollars)!
  }

  /**
   un-prettify string to get the number as string. Removes dollar signs and commas.
   */
  func unFormatDollars(amount: String) -> String {
    var newAmount = amount.stringByReplacingOccurrencesOfString("$", withString: "")
    newAmount = newAmount.stringByReplacingOccurrencesOfString(",", withString: "")
    return newAmount
  }

  
}
