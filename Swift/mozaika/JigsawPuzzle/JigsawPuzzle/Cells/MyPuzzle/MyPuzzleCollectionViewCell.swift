//
//  MyPuzzleCollectionViewCell.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 23.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

class MyPuzzleCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var puzzleImageView: UIImageView!
  @IBOutlet weak var endPuzzleImageView: UIImageView!
  @IBOutlet weak var percentLabel: UILabel!
  @IBOutlet weak var trashButton: UIButton!
  @IBOutlet weak var continueButton: UIButton!
  
  override func prepareForReuse() {
    puzzleImageView.image = nil
  }
}
