//
//  FindFlightsTableViewCell.swift
//  ticketBus
//
//  Created by Elatesoftware on 16.08.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class FindFlightsTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var findLabel: UILabel!
  @IBOutlet weak var imageFind: UIImageView!
  @IBOutlet weak var startLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
