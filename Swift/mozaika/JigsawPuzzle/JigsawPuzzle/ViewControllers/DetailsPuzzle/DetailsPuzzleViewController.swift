//
//  DetailsPuzzleViewController.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 09.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit
import SDWebImage

class DetailsPuzzleViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var slider: StepSlider!
  @IBOutlet weak var stepPuzzleLabel: UILabel!
  
  private let titleViewController = NSLocalizedString("countPuzzle", comment: "")
  var puzzle: PicturesModel!
  
  private let countsPuzzle = [9, 16, 25, 36, 49, 64, 81, 100]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    slider.maxCount = UInt(countsPuzzle.count)
    imageView.sd_setImage(with: URL(string: puzzle.pictures), completed: nil)
    
    title = titleViewController
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    
    removeTitleBackBarButtonItem()
  }
  
  @IBAction func startPuzzleButtonAction(_ sender: ATButton) {
    if let controller = PuzzleGameViewController.instantiateInitialViewController() as? PuzzleGameViewController {
      guard let image = imageView.image else { return }
      controller.image = image
      controller.countPuzzle = countsPuzzle[Int(slider.index)]
      controller.idImage = puzzle.id
      controller.currentState = .newPuzzle
      
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  @IBAction func changeValue(_ sender: StepSlider) {
    stepPuzzleLabel.text = "\(countsPuzzle[Int(sender.index)])"
  }
}
