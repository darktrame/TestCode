//
//  EndPuzzleViewController.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 16.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

protocol EndPuzzleViewControllerDelegate {
  func goToRootViewController()
}

class EndPuzzleViewController: UIViewController {
  private let shareText = "I’ve just solved this puzzle in the My Jigsaw Puzzles app"
  
  var delegate: EndPuzzleViewControllerDelegate?
  var imageForShare: UIImage!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setStatusBarColor(with: .white)
  }
  
  func setStatusBarColor(with color: UIColor) {
    guard let statusBar = UIApplication.shared.statusBarView else { return }
    statusBar.backgroundColor = color
  }
  
  @IBAction func endButtonAction(_ sender: ATButton) {
    if let respond = self.delegate?.goToRootViewController() {
      respond
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func shareButtonAction(_ sender: Any) {
    let activityVC = UIActivityViewController(activityItems: [shareText, imageForShare],
                                              applicationActivities: nil)
    activityVC.popoverPresentationController?.sourceView = view
    
    present(activityVC, animated: true, completion: nil)
  }
}
