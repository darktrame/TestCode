//
//  TicketPlusInsuranceTableViewCell.swift
//  ticketBus
//
//  Created by Elatesoftware on 10.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class TicketPlusInsuranceTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var costTicket: UILabel!
  @IBOutlet weak var costInsurance: UILabel!
  @IBOutlet weak var getTicketButton: UIButton!
  @IBOutlet weak var getInsuranceButton: UIButton!
  @IBOutlet weak var returnTicketButton: UIButton!
  @IBOutlet weak var returnInsuranceButton: UIButton!
  
  // MARK: - Variables
  var ticketLink = ""
  var insuranceLink = ""
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
