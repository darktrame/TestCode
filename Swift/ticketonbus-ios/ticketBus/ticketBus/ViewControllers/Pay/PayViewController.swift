//
//  PayViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 06.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {
  // MARK: - Outelts
  @IBOutlet weak var currentCostLabel: UILabel!
  
  // MARK: - Variables
  var link = ""
  var cost: Float = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Оплата"
    
    currentCostLabel.text = "К оплате:  \(String(format: "%.2f", cost)) P"
    
    view.backgroundColor = UIColor.blueTicketBusTableColor
  }
  
  // MARK: - Actions
  @IBAction func payButtonAction(_ sender: UIButton) {
    if let controller = WebViewController.viewController() as? WebViewController {
      controller.link = self.link
      controller.titleString = "Оплата"
      
      navigationController?.pushViewController(controller, animated: true)
    }
  }
}
