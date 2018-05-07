//
//  ATButton.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 09.02.18.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

class ATButton: UIButton {
  @IBInspectable var border: Bool = false
  @IBInspectable var borderColor: UIColor = UIColor.clear
  @IBInspectable var borderWidth: CGFloat = 0.0
  @IBInspectable var isCurcular: Bool = false

  @IBInspectable var shadow: Bool = false
  @IBInspectable var shadowColor: UIColor = UIColor.clear
  @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0)
  @IBInspectable var shadowOpacity: Float = 0.0
  @IBInspectable var shadowRadius: CGFloat = 0.0

  @IBInspectable var scaleFactor: CGFloat = 1.0
  @IBInspectable var cornerRadius: CGFloat = 0.0
  @IBInspectable var numberOfLines: Int = 1
  @IBInspectable var isLineBorder: Bool = false
  
  var borderLayer:CALayer?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.cornerRadius = isCurcular ? self.bounds.height / 2 : cornerRadius

    if border {
      let border = CALayer()
      let size = self.frame.size
      
      border.borderColor = borderColor.cgColor
      border.frame = CGRect(x: 0.0, y: isLineBorder ? size.height - borderWidth : 0.0, width: size.width, height: size.height)
      border.borderWidth = borderWidth
      border.cornerRadius = isCurcular ? self.bounds.height / 2 : cornerRadius
      
      self.layer.addSublayer(border)
      self.layer.masksToBounds = true
      
      self.borderLayer = border
    }

    if shadow {
      self.layer.shadowColor = shadowColor.cgColor
      self.layer.shadowOffset = shadowOffset
      self.layer.shadowOpacity = shadowOpacity
      self.layer.shadowRadius = shadowRadius

      self.clipsToBounds = false
    } else {
      self.clipsToBounds = true
    }

    titleLabel?.minimumScaleFactor = scaleFactor
    titleLabel?.numberOfLines = numberOfLines
    titleLabel?.adjustsFontSizeToFitWidth = true
    titleLabel?.lineBreakMode = .byClipping
  }
}
