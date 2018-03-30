//
//  UIApplication+StatusBar.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 09.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

extension UIApplication {
  var statusBarView: UIView? {
    return value(forKey: "statusBar") as? UIView
  }
}
