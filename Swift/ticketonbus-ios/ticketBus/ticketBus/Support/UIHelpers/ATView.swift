//
//  ATView.swift
//  ticketBus
//
//  Created by Elatesoftware on 12.05.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class ATView: UIView {
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
  @IBInspectable var cornerRadius: CGFloat = 0.0

  @IBInspectable var isBordered: Bool = false
  @IBInspectable var borderColor: UIColor = UIColor.clear
  @IBInspectable var borderWidth: CGFloat = 0.0

  var topInnerShadow: CALayer?
  var bottomInnerShadow: CALayer?
  var leftInnerShadow: CALayer?
  var rightInnerShadow: CALayer?

  override func awakeFromNib() {
    super.awakeFromNib()

    if isInnerShadow {
      let size = self.frame.size

      if topShadow {
        if topInnerShadow == nil {
          topInnerShadow = drawInnerShadow(layerPosition: CGPoint(x: size.width / 2, y: -size.height / 2))
        }
      }

      if bottomShadow {
        if bottomInnerShadow == nil {
          bottomInnerShadow = drawInnerShadow(layerPosition: CGPoint(x: size.width / 2, y: size.height * 1.5))
        }
      }

      if leftShadow {
        if leftInnerShadow == nil {
          leftInnerShadow = drawInnerShadow(layerPosition: CGPoint(x: -size.width / 2, y: size.height / 2))
        }
      }

      if rightShadow {
        if rightInnerShadow == nil {
          rightInnerShadow = drawInnerShadow(layerPosition: CGPoint(x: size.width * 1.5, y: size.height / 2))
        }
      }

      self.clipsToBounds = true

    } else {
      drawOuterShadow()
      self.clipsToBounds = false
    }

    self.layer.cornerRadius =  isCurcular ? self.bounds.height / 2 : cornerRadius

    if isBordered {
      self.layer.borderColor = borderColor.cgColor
      self.layer.borderWidth = borderWidth
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
}
