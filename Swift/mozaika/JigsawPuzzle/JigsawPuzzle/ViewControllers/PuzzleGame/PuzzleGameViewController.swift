//
//  PuzzleGameViewController.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 12.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit
import PuzzleMaker

enum TypeState {
  case newPuzzle
  case continuePuzzle
}

class PuzzleGameViewController: UIViewController, UIGestureRecognizerDelegate {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
  
  var image: UIImage!
  var countPuzzle: Int = 0
  var idImage: Int = 0
  var currentState = TypeState.newPuzzle
  
  private var trayOriginalCenter: CGPoint!
  private var copyImageView: UIImageView?
  private var copyPosition: (row: Int, column: Int)?
  private var originalImageView: UIImageView?
  private var puzzleManager: PuzzleManager!
  private var panGesture: UIPanGestureRecognizer!
  private var maxHeight: CGFloat = 0.0
  private let elementIdentifier = String(describing: ElementCollectionViewCell.self)
  private var selectedIndexPath: IndexPath?
  
  private var backItem: UIBarButtonItem? {
    let index = navigationController?.viewControllers.index(of: self) ?? 1
    return navigationController?.viewControllers[index - 1].navigationItem.backBarButtonItem
  }
  
  
  private var isShow = false {
    didSet {
      setNavigationBar()
    }
  }
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    let local = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: view)
    return local.y < 0
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let size = CGSize(width: view.bounds.width * 2.0, height: view.bounds.width * 2.0)
    puzzleManager = PuzzleManager(withImage: image, countPuzzle: countPuzzle,
                                  size: size, delegate: self, imageId: idImage)
    
    setControllerOptions()
    
    NotificationCenter.default.addObserver(self, selector: #selector(disableDragging), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(enableDragging), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    guard !collectionView.indexPathsForVisibleItems.isEmpty else { return }
    collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                at: .left, animated: false)
  }
  
  @objc func disableDragging() {
    panGesture.isEnabled = false
  }
  
  @objc func enableDragging() {
    panGesture.isEnabled = true
  }
  
  func setControllerOptions() {
    panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
    panGesture.delegate = self
    
    collectionView.addGestureRecognizer(panGesture)
    
    isShow = false
    collectionView.dataSource = self
    collectionView.delegate = self
    
    let nib = UINib(nibName: elementIdentifier, bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: elementIdentifier)
    
    guard UIScreen.main.bounds.height == 568.0 else { return }
    collectionViewBottomConstraint.constant = countPuzzle > 80 ? 40.0 : 8.0
    view.layoutIfNeeded()
  }
  
  func setNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: !isShow ? #imageLiteral(resourceName: "hide_puzzle") : #imageLiteral(resourceName: "show_puzzle"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(showOrHidePuzzle(_:)))
  }
  
  @objc
  func panGesture(_ sender: UIPanGestureRecognizer) {
    let location = sender.location(in: view)
    switch (sender.state) {
    case .began:
      guard let selectedIndexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)),
        let cell = collectionView.cellForItem(at: selectedIndexPath) as? ElementCollectionViewCell,
        let imageView = cell.contentView.subviews.first as? UIImageView,
        copyImageView == nil else { return }
      self.selectedIndexPath = selectedIndexPath
      copyPosition = cell.numberElement
      
      let copyFrame = imageView.convert(imageView.frame, to: view)
      copyImageView = UIImageView(frame: copyFrame)
      copyImageView!.image = imageView.image
      copyImageView!.contentMode = imageView.contentMode
      
      originalImageView = imageView
      
      trayOriginalCenter = imageView.convert(imageView.center, to: view)
      view.addSubview(copyImageView!)
      imageView.isHidden = true
    case .changed:
      guard copyImageView != nil else { break }
      copyImageView!.center = CGPoint(x: location.x, y: location.y - 70.0)
    case .ended:
      guard copyImageView != nil else { return }
      guard
        let rect = puzzleManager.checkPuzzleAndGetOriginalRect(withLocation: copyImageView!.center,
                                                               needPosition: copyPosition) else {
                                                                copyImageView?.removeFromSuperview()
                                                                originalImageView?.isHidden = false
                                                                self.copyImageView = nil
                                                                
                                                                break
      }
      
      UIView.animate(withDuration: 0.3, animations: {
        self.copyImageView?.frame = rect
      })
      
      guard let indexPath = selectedIndexPath else { break }
      collectionView.deleteItems(at: [indexPath])
      puzzleManager.save()
      self.copyImageView = nil
    default: break
    }
  }
  
  @objc
  func showOrHidePuzzle(_ sender: UIBarButtonItem) {
    isShow = !isShow

    let puzzle = self.view.subviews
      .filter {$0.isKind(of: UIImageView.self) && $0.alpha == 0.5}
      .flatMap {($0 as! UIImageView)}
    
    for (index, object) in puzzle.enumerated() {
      object.image = !isShow ? puzzleManager.getPuzzle(withType: .original)[index].image
        : puzzleManager.getPuzzle(withType: .white)[index].image
    }
  }
}

extension PuzzleGameViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return puzzleManager.getPuzzle(withType: .elements).count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: elementIdentifier, for: indexPath)
      as? ElementCollectionViewCell else { return UICollectionViewCell() }
    
    let element = puzzleManager.getPuzzle(withType: .elements)[indexPath.item]
    
    cell.elementImageView.isHidden = false
    cell.elementImageView.image = element.image
    cell.elementImageView.contentMode = UIDevice.current.userInterfaceIdiom == .phone ? .center : .scaleAspectFit
    
    cell.numberElement = (element.position.row, element.position.column)
    
    return cell
  }
}

extension PuzzleGameViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = puzzleManager.getPuzzle(withType: .elements)[indexPath.item].image.size.width
    let height = UIDevice.current.userInterfaceIdiom == .phone ? maxHeight : 313.0
    return CGSize(width: width, height: height)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    panGesture.isEnabled = true
  }
}

extension PuzzleGameViewController: PuzzleManagerDelegate {
  func puzzleDidFinishLoaded(_ removedPuzzle: [PuzzleTyple]) {
    for object in removedPuzzle {
      let imageView = UIImageView(image: object.image)
      imageView.frame = CGRect(origin: object.position.point, size: object.image.size)
      view.addSubview(imageView)
    }
  }
  
  @objc
  func presentEndPuzzle() {
    if let controller = EndPuzzleViewController.instantiateInitialViewController() as? EndPuzzleViewController {
      controller.modalTransitionStyle = .crossDissolve
      controller.delegate = self
      controller.imageForShare = puzzleManager.getOriginalImage()
      present(controller, animated: true, completion: nil)
    }
  }
  
  func puzzleDidFinish() {
    backItem?.isEnabled = false
    navigationItem.backBarButtonItem = backItem
    perform(#selector(presentEndPuzzle), with: self, afterDelay: 1.5)
  }
  
  func puzzleDidGenerated(_ originalPuzzle: [PuzzleTyple], puzzleElementsImages: [PuzzleTyple], maxHeightPuzzle: CGFloat) {
    for puzzle in originalPuzzle {
      let imageView = UIImageView(frame: CGRect(x: puzzle.position.point.x,
                                                y: puzzle.position.point.y,
                                                width: puzzle.image.size.width,
                                                height: puzzle.image.size.height))
      imageView.image = puzzle.image
      imageView.alpha = 0.5
      view.addSubview(imageView)
    }
    
    setCollectionViewOptions(maxHeightPuzzle)
    
    if currentState == .continuePuzzle {
      puzzleManager.load()
    }
    
    collectionView.reloadData()
  }
  
  func setCollectionViewOptions(_ maxHeightPuzzle: CGFloat) {
    maxHeight = maxHeightPuzzle * 1.68
    collectionViewHeightConstraint.constant = UIDevice.current.userInterfaceIdiom == .phone ? maxHeight : 313.0
    view.layoutIfNeeded()
  }
}

extension PuzzleGameViewController: EndPuzzleViewControllerDelegate {
  func goToRootViewController() {
    navigationController?.popToRootViewController(animated: true)
  }
}
