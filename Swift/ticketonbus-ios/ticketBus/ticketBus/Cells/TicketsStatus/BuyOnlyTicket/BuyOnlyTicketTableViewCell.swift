//
//  BuyOnlyTicketTableViewCell.swift
//  ticketBus
//
//  Created by Elatesoftware on 10.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class BuyOnlyTicketTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var costTicket: UILabel!
  @IBOutlet weak var getTicketButton: UIButton!
  @IBOutlet weak var returnTicketButton: UIButton!
  
  // MARK: - Variables
  var ticketLink = ""
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
