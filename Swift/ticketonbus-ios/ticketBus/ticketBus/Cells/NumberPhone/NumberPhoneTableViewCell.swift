//
//  NumberPhoneTableViewCell.swift
//  ticketBus
//
//  Created by Elatesoftware on 06.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class NumberPhoneTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var numberLabel: UILabel!
  @IBOutlet weak var phoneImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
