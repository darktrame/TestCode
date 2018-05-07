//
//  ATDynamicButton.swift
//  ticketBus
//
//  Created by Elatesoftware on 18.05.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

@IBDesignable class ATDynamicButton: UIButton {
  @IBInspectable var scaleFactor: CGFloat = 1.0
  @IBInspectable var numberOfLines: Int = 1
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    titleLabel?.minimumScaleFactor = scaleFactor
    titleLabel?.numberOfLines = numberOfLines
    titleLabel?.adjustsFontSizeToFitWidth = true
    titleLabel?.lineBreakMode = .byTruncatingMiddle
  }
}
