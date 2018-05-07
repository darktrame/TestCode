//
//  ReturnOnlyTicketTableViewCell.swift
//  ticketBus
//
//  Created by Elatesoftware on 12.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class ReturnOnlyTicketTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var costTicket: UILabel!
  @IBOutlet weak var returnCost: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
