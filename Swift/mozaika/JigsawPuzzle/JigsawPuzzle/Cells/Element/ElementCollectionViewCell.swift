//
//  ElementCollectionViewCell.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 16.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

class ElementCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var elementImageView: UIImageView!
  
  var numberElement: (row: Int, column: Int)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
