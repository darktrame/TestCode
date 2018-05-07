//
//  GlobalViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 21.08.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class GlobalViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavigationBarItems()
  }
  
  func setNavigationBarItems() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navbar_menu"),
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(openLeftMenu))
  }
  
  @objc func openLeftMenu() {
    showLeftViewAnimated(nil)
  }
}
