//
//  PuzzleCollectionViewCell.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 09.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

class PuzzleCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var mainView: ATView!
  @IBOutlet weak var pictures: UIImageView!
  @IBOutlet weak var locImageView: UIImageView!
  
  var borderColor: UIColor?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    pictures.image = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    mainView.layer.borderColor = borderColor?.cgColor
  }
  
//  override func layoutSubviews() {
//    super.layoutSubviews()
//    
//    guard let color = borderColor else { return }
//    mainView.layer.borderColor = color.cgColor
//  }
}
