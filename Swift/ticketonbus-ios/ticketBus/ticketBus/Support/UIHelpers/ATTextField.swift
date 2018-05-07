//
//  ATTextField.swift
//  ticketBus
//
//  Created by Elatesoftware on 18.05.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class ATTextField: UITextField {
  @IBInspectable var placeholderColor: UIColor = UIColor.darkGray
  @IBInspectable var bottomBorderWidth: CGFloat = 1.0
  @IBInspectable var borderColor: UIColor = UIColor.white
  @IBInspectable var cornerRadius: CGFloat = 0.0
  
  @IBInspectable var isInnerShadow: Bool = false
  
  @IBInspectable var topShadow: Bool = false
  @IBInspectable var bottomShadow: Bool = false
  @IBInspectable var leftShadow: Bool = false
  @IBInspectable var rightShadow: Bool = false
  
  @IBInspectable var shadowColor: UIColor = UIColor.clear
  @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0)
  @IBInspectable var shadowOpacity: Float = 1.0
  @IBInspectable var shadowRadius: CGFloat = 0.0
  @IBInspectable var contentInSet: CGSize = CGSize(width: 0.0, height: 0.0)
  
  @IBInspectable var isCurcular: Bool = false
  
  @IBInspectable var leftImage: UIImage?
  
  @IBInspectable var leftPadding: CGFloat = 0
  @IBInspectable var imageColor: UIColor = UIColor.black
  
  @IBInspectable var leftTextView: String? {
    didSet {
      updateView()
    }
  }
  
  @IBInspectable var leftTextColorView: UIColor = .white
  var leftTextFontView: UIFont = UIFont(name: "SFUIDisplay-Light", size: 16)!
  
  var borderLayer: CALayer?
  
  
  var topInnerShadow: CALayer?
  var bottomInnerShadow: CALayer?
  var leftInnerShadow: CALayer?
  var rightInnerShadow: CALayer?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if borderLayer == nil {
      let border = CALayer()
      let size = self.frame.size
      
      border.borderColor = borderColor.cgColor
      border.frame = CGRect(x: 0, y: size.height - bottomBorderWidth, width: size.width, height: size.height)
      border.borderWidth = bottomBorderWidth
      
      self.layer.addSublayer(border)
      self.layer.masksToBounds = true
      
      self.borderLayer = border
      
      attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor : placeholderColor])
    }
  }
  
  func drawOuterShadow() {
    layer.shadowColor = shadowColor.cgColor
    layer.shadowOffset = shadowOffset
    layer.shadowOpacity = shadowOpacity
    layer.shadowRadius = shadowRadius
    
    var newBounds = layer.bounds
    
    newBounds.origin.x += contentInSet.width
    newBounds.size.width -= 2 * contentInSet.width
    
    newBounds.origin.y += contentInSet.height
    newBounds.size.height -= 2 * contentInSet.height
    
    layer.bounds = newBounds
  }
  
  func drawInnerShadow(layerPosition position: CGPoint) -> CALayer {
    let size = self.frame.size
    
    let shadowLayer: CALayer = CALayer()
    
    shadowLayer.backgroundColor = UIColor.lightGray.cgColor
    shadowLayer.position = position
    shadowLayer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    
    shadowLayer.shadowColor = shadowColor.cgColor
    shadowLayer.shadowOffset = shadowOffset
    shadowLayer.shadowOpacity = shadowOpacity
    shadowLayer.shadowRadius = shadowRadius
    
    self.layer.addSublayer(shadowLayer)
    
    return shadowLayer
  }
  
  override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    var textRect = super.leftViewRect(forBounds: bounds)
    textRect.origin.x += leftPadding
    return textRect
  }
  
  func updateView() {
    if let image = leftImage {
      leftViewMode = UITextFieldViewMode.always
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
      imageView.image = image.withRenderingMode(.alwaysTemplate)
      imageView.tintColor = .white
      imageView.contentMode = .scaleAspectFit
      
      let view = UIView(frame: CGRect(x: 0, y: 0, width: 108, height: 20))
      view.addSubview(imageView)
      
      let staticLabel = UILabel(frame: CGRect(x: 30, y: 0, width: 80, height: 20))
      staticLabel.text = leftTextView
      staticLabel.textColor = .white
      staticLabel.font = leftTextFontView
      
      view.addSubview(staticLabel)
      leftView = view
    } else {
      leftViewMode = UITextFieldViewMode.never
      leftView = nil
    }
  }
  
  //  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
  //    return UIEdgeInsetsInsetRect(bounds,
  //                                 UIEdgeInsetsMake(0, 51, 0, 51))
  //  }
}

