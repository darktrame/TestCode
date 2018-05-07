//
//  MyPuzzleViewController.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 23.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit
import SDWebImage
//import Crashlytics

class MyPuzzleViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var emptyLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  typealias PuzzleType = (puzzle: PicturesModel, percent: Int)
  
  fileprivate let puzzleIdentifier = String(describing: MyPuzzleCollectionViewCell.self)
  fileprivate var myPuzzles: [PuzzleType] = []
  private let shareText = "I’ve just solved this puzzle in the My Jigsaw Puzzles app"
  
  var applicationModel: ApplicationModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = NSLocalizedString("myPuzzle", comment: "")
    
    removeTitleBackBarButtonItem()
    setUpCollectionView()
    
    //Crashlytics.sharedInstance().crash()
  }
  
  private func setUpCollectionView() {
    collectionView.register(UINib(nibName: puzzleIdentifier, bundle: nil),
                            forCellWithReuseIdentifier: puzzleIdentifier)
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let savePuzzle = UserDefaults.standard.dictionary(forKey: "savePuzzle")
    if savePuzzle != nil {
      let puzzle = applicationModel.picturesPuzzle.filter({ (object) -> Bool in
        return savePuzzle!.keys.contains(String(object.id))
      })
      
      myPuzzles = puzzle.flatMap({ (puzzle) -> (puzzle: PicturesModel, percent: Int) in
        return (puzzle, savePuzzle![String(puzzle.id)] as! Int)
      })
    }
    
    collectionView.reloadData()
  }
  
  private func showAlert(_ indexPath: IndexPath) {
    let alert = UIAlertController(title: NSLocalizedString("confirmRemove", comment: ""),
                                  message: NSLocalizedString("removeMessage", comment: ""),
                                  preferredStyle:.actionSheet)
    let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
    let delete = UIAlertAction(title: NSLocalizedString("remove", comment: ""), style: .default) { _ in
      var savePuzzle = UserDefaults.standard.dictionary(forKey: "savePuzzle")
      savePuzzle?.removeValue(forKey: String(self.myPuzzles[indexPath.item].puzzle.id))
      UserDefaults.standard.set(savePuzzle, forKey: "savePuzzle")
      
      self.myPuzzles.remove(at: indexPath.item)
      self.collectionView.deleteItems(at: [indexPath])
    }
    
    delete.setValue(UIColor.red, forKey: "titleTextColor")
    
    alert.addAction(cancel)
    alert.addAction(delete)
    
    alert.popoverPresentationController?.sourceView = (collectionView.cellForItem(at: indexPath)
      as? MyPuzzleCollectionViewCell)?.trashButton
    present(alert, animated: true, completion: nil)
  }
}

extension MyPuzzleViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    emptyLabel.isHidden = myPuzzles.count != 0
    return myPuzzles.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: puzzleIdentifier,
                                                        for: indexPath) as? MyPuzzleCollectionViewCell else {
                                                          return UICollectionViewCell()
    }
    
    cell.puzzleImageView.sd_setImage(with: URL(string: myPuzzles[indexPath.item].puzzle.preview),
                                     completed: nil)
    let percent = myPuzzles[indexPath.item].percent
    cell.percentLabel.text = String(percent)
    
    let fullPuzzle = percent == 100
    cell.endPuzzleImageView.isHidden = !fullPuzzle
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(newPuzzleGesture(_:)))
    cell.endPuzzleImageView.addGestureRecognizer(tapGesture)
    
    cell.trashButton.addTarget(self, action: #selector(trashButtonAction(_:)), for: .touchUpInside)
    cell.continueButton.addTarget(self, action: #selector(continueButtonAction(_:)), for: .touchUpInside)
    
    cell.continueButton.setImage(fullPuzzle ? #imageLiteral(resourceName: "share") : #imageLiteral(resourceName: "contin"), for: .normal)
    
    return cell
  }
}

extension MyPuzzleViewController: UICollectionViewDelegateFlowLayout {
  
}

extension MyPuzzleViewController {
  @objc
  func trashButtonAction(_ sender: UIButton) {
    guard
      let cell = sender.superview?.superview?.superview?.superview as? MyPuzzleCollectionViewCell,
      let indexPath = collectionView.indexPath(for: cell) else { return }
    showAlert(indexPath)
  }
  
  @objc
  func continueButtonAction(_ sender: UIButton) {
    guard
      let cell = sender.superview?.superview?.superview?.superview as? MyPuzzleCollectionViewCell,
      let indexPath = collectionView.indexPath(for: cell) else { return }
    
    let currentPuzzle = myPuzzles[indexPath.item]
    
    guard currentPuzzle.percent != 100 else {
      share(cell.puzzleImageView.image!)
      return
    }

    guard let url = URL(string: currentPuzzle.puzzle.pictures) else { return }
    loadImage(url, currentPuzzle: currentPuzzle, indexPath: indexPath)
  }
  
  func loadImage(_ pictures: URL, currentPuzzle: PuzzleType, indexPath: IndexPath) {
    activityIndicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
    
    DispatchQueue.global(qos: .userInteractive).async {
      guard let data = try? Data(contentsOf: pictures), let image = UIImage(data: data) else {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        return
      }
      
      DispatchQueue.main.async {
        UIApplication.shared.endIgnoringInteractionEvents()
        self.activityIndicator.stopAnimating()
        self.continuePuzzle(currentPuzzle, id: String(self.myPuzzles[indexPath.item].puzzle.id), imagePuzzle: image)
      }
    }
  }
  
  @objc
  func newPuzzleGesture(_ sender: UITapGestureRecognizer) {
    guard
      let cell = sender.view?.superview?.superview?.superview?.superview as? MyPuzzleCollectionViewCell,
      let indexPath = collectionView.indexPath(for: cell) else { return }
    
    let currentPuzzle = myPuzzles[indexPath.item]
    newPuzzle(currentPuzzle)
  }
  
  func share(_ image: UIImage) {
    let activityVC = UIActivityViewController(activityItems: [shareText, image],
                                              applicationActivities: nil)
    activityVC.popoverPresentationController?.sourceView = view
    
    present(activityVC, animated: true, completion: nil)
  }
}

extension MyPuzzleViewController {
  func newPuzzle(_ puzzleModel: PuzzleType) {
    guard let controller = DetailsPuzzleViewController.instantiateInitialViewController()
      as? DetailsPuzzleViewController else { return }
    controller.puzzle = puzzleModel.puzzle
    navigationController?.pushViewController(controller, animated: true)
  }
  
  func continuePuzzle(_ puzzle: PuzzleType, id: String, imagePuzzle: UIImage?) {
    guard let myPuzzlesCount = UserDefaults.standard.dictionary(forKey: "myPuzzlesCount"),
      let count = myPuzzlesCount[id] as? Int else { return }
  
    if let controller = PuzzleGameViewController.instantiateInitialViewController() as? PuzzleGameViewController {
      guard let image = imagePuzzle else { return }
      controller.image = image
      controller.countPuzzle = count
      controller.idImage = puzzle.puzzle.id
      controller.currentState = .continuePuzzle

      navigationController?.pushViewController(controller, animated: true)
    }
  }
}
