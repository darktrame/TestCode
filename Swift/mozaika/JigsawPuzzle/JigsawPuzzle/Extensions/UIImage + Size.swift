//
//  UIImage + Size.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 13.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

extension UIImage {
  func resizedImage(newSize targetSize: CGSize) -> UIImage? {
    let size = self.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
      newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
      newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
//    UIGraphicsBeginImageContext(size)
//    draw(in: CGRect(origin: .zero, size: size))
//    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
//      return nil
//    }
//    UIGraphicsEndImageContext()
//    return newImage
  }
  
  func imageWithColor(tintColor: UIColor, path: UIBezierPath) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
    
    let context = UIGraphicsGetCurrentContext()!
    context.translateBy(x: 0.0, y: self.size.height)
    context.scaleBy(x: 1.0, y: -1.0)
    context.setBlendMode(.normal)
    
    let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
    context.clip(to: rect, mask: self.cgImage!)
    tintColor.setFill()
    context.fill(rect)
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    let imageWithLightInnerShadow = newImage!.applyInnerShadow(forPath: path, shadowColor: UIColor.black, shadowOffset: CGSize(width: 1, height: 1), shadowBlurRadius: 2)
    
    UIGraphicsEndImageContext()
    
    return imageWithLightInnerShadow!
  }
}
