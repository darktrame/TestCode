//
//  CategoriesPuzzleTableViewCell.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 09.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit
import SDWebImage

protocol CategoriesPuzzleTableViewCellDelegate {
  func userDidChangePuzzle(_ puzzle: PicturesModel)
}

class CategoriesPuzzleTableViewCell: UITableViewCell {
  @IBOutlet weak var categoryImageView: UIImageView!
  @IBOutlet weak var titleCategoryLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  fileprivate let puzzleCellIdentifier = String(describing: PuzzleCollectionViewCell.self)
  var borderColor: UIColor?
  var delegate: CategoriesPuzzleTableViewCellDelegate?
  var puzzle: [PicturesModel] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = .none
    backgroundColor = .clear
    
    setCollectionViewSettings()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    collectionView.reloadData()
  }
  
  func setCollectionViewSettings() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UINib(nibName: puzzleCellIdentifier, bundle: nil),
                            forCellWithReuseIdentifier: puzzleCellIdentifier)
  }
}

// MARK: - UICollectionViewDataSource
extension CategoriesPuzzleTableViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return puzzle.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: puzzleCellIdentifier, for: indexPath) as? PuzzleCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.pictures.sd_setImage(with: URL(string: puzzle[indexPath.item].preview), completed: nil)
 //   cell.pictures.sd_setImage(with: URL(string: puzzle[indexPath.item].pictures),
 //                             completed: nil)
    cell.borderColor = borderColor
    cell.locImageView.isHidden = User.isPremiumVersionActive ? true : !puzzle[indexPath.item].isChargable
    
    return cell
  }
  
//  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    guard let cell = cell as? PuzzleCollectionViewCell else {return}
//    cell.pictures.sd_setImage(with: URL(string: puzzle[indexPath.item].pictures), placeholderImage: nil, options: .scaleDownLargeImages, completed: nil)
//  }
  
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let cell = cell as? PuzzleCollectionViewCell else {return}
    cell.pictures.sd_cancelCurrentImageLoad()
  }
}

// MARK: - UICollectionViewDelegate
extension CategoriesPuzzleTableViewCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    
    if let respond = delegate?.userDidChangePuzzle(puzzle[indexPath.item]) { respond }
  }
}
