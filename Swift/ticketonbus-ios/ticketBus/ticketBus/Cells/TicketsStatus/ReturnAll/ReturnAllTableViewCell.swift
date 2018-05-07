//
//  ReturnAllTableViewCell.swift
//  ticketBus
//
//  Created by Elatesoftware on 10.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class ReturnAllTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var costTicket: UILabel!
  @IBOutlet weak var costInsurance: UILabel!
  @IBOutlet weak var returnCostTicket: UILabel!
  @IBOutlet weak var returnInsuranceCost: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
