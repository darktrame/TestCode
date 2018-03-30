//
//  UIViewController+Storyboard.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 09.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

extension UIViewController {
  static func instantiateInitialViewController() -> UIViewController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController()
  }
  
  static func instantiateViewController(with identifier: String) -> UIViewController {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: identifier)
  }
}
