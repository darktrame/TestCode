//
//  InsuranceViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 12.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class InsuranceViewController: GlobalViewController {
  // MARK: - Variables
  let links = ["https://ticketonbus.ru/assets/media/insurance/rules.pdf",
               "https://ticketonbus.ru/assets/media/insurance/offer.pdf",
               "https://ticketonbus.ru/assets/media/insurance/addition.pdf"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Страховка"
    
    view.backgroundColor = UIColor.blueTicketBusTableColor
  }
  
  // MARK: - Actions
  @IBAction func showLinkButtonAction(_ sender: UIButton) {
    if let controller = WebViewController.viewController() as? WebViewController {
      controller.titleString = sender.titleLabel?.text ?? ""
      controller.link = links[sender.tag]
      navigationController?.pushViewController(controller, animated: true)
    }
  }
}
