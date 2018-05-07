//
//  SiteCollectionViewCell.swift
//  ticketBus
//
//  Created by Elatesoftware on 05.09.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class SiteCollectionViewCell: UICollectionViewCell {
  // MARK: - Outlets
  @IBOutlet weak var number_seat_label: UILabel!
  @IBOutlet weak var viewSeat: ATView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
