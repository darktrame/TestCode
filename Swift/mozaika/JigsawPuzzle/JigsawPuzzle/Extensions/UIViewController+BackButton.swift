//
//  UIViewController+BackButton.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 09.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

extension UIViewController {
  func removeTitleBackBarButtonItem() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                       style: .done,
                                                       target: nil,
                                                       action: nil)
  }
}
