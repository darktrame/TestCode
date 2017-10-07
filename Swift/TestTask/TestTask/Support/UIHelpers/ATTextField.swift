//
//  ATTextField.swift
//  
//
//  Created by Elatesoftware on 18.05.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class ATTextField: UITextField {
  @IBInspectable var placeholderColor: UIColor = UIColor.darkGray
  @IBInspectable var bottomBorderWidth: CGFloat = 1.0
  @IBInspectable var borderColor: UIColor = UIColor.white
  
  var borderLayer: CALayer?
  
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
      
      attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                 attributes: [NSForegroundColorAttributeName:
                                                  placeholderColor])
    }
  }
}
