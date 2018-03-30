//
//  UIViewController+UIAlertController.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 09.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

extension UIViewController {
  func showInformationAlert(with message: String) -> UIAlertController {
    let alertController = UIAlertController(title: nil,
                                            message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK",
                                 style: .cancel, handler: nil)
    alertController.addAction(okAction)
    
    return alertController
  }
}
