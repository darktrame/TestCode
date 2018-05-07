//
//  PhotoScrollView.swift
//  ticketBus
//
//  Created by Elatesoftware on 11.10.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoScrollView: UIScrollView {
  // MARK: - Variables
  var isPopulated = false
  
  func populate(with photos: [UIImage]) {
    self.contentSize = CGSize(width: self.frame.width * CGFloat(photos.count),
                              height: self.frame.height)
    for (index, photo) in photos.enumerated() {
      let imageView = UIImageView(frame: CGRect(x:self.frame.width * CGFloat(index),
                                                y:0,
                                                width:self.frame.width,
                                                height:self.frame.height))
      imageView.contentMode = .scaleAspectFill
      imageView.image = photo
      
      self.addSubview(imageView)
    }
    
    self.isPopulated = true
  }
}
