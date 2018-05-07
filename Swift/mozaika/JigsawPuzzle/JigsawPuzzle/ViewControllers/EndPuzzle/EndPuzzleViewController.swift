//
//  EndPuzzleViewController.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 16.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit
import StoreKit

protocol EndPuzzleViewControllerDelegate {
  func goToRootViewController()
}

class EndPuzzleViewController: UIViewController {
  private let shareText = "I’ve just solved this puzzle in the My Jigsaw Puzzles app"
  private let link = "https://itunes.apple.com/by/app/your-jigsaw-puzzles/id1353739934?mt=8"
  
  var delegate: EndPuzzleViewControllerDelegate?
  var imageForShare: UIImage!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setStatusBarColor(with: .white)
  }
  
  func showAlert() {
    let alert = UIAlertController(title: NSLocalizedString("rate", comment: ""),
                                  message: NSLocalizedString("rateText", comment: ""), preferredStyle: .alert)
    let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
      self.rateApp(appId: "id1353739934") { (result) in
        if result {
          User.rateUser = true
        }
      }
    }
    
    let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
    alert.addAction(ok)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !User.rateUser && User.countRate < 2 {
      User.countRate = User.countRate + 1
      if #available(iOS 10.3, *) {
        SKStoreReviewController.requestReview()
      } else {
        showAlert()
      }
    }
  }
  
  func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
    guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
      completion(false)
      return
    }
    guard #available(iOS 10, *) else {
      completion(UIApplication.shared.openURL(url))
      return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: completion)
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
    let activityVC = UIActivityViewController(activityItems: [shareText, imageForShare, link],
                                              applicationActivities: nil)
    activityVC.popoverPresentationController?.sourceView = view
    
    present(activityVC, animated: true, completion: nil)
  }
}
