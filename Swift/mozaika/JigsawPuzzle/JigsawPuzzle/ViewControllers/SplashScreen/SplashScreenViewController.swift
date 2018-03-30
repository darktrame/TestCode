//
//  SplashScreenViewController.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 08.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var reconnectButton: ATButton!
  @IBOutlet weak var nameAppImageView: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  private let afterDelayTimer = 2.0
  private let durationTimer = 0.3
  private let applicationModel = ApplicationModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    showError(false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loadPuzzle()
  }
  
  private func loadPuzzle() {
    showError(false)
    ConnectionManager.sharedInstance.getPicturesLibrary { (response, error) in
      guard error == nil, let picturesPuzzle = response else { self.showError(true); return }
      self.perform(#selector(self.setRootController), with: nil, afterDelay: self.afterDelayTimer)
      self.applicationModel.picturesPuzzle = picturesPuzzle
    }
  }
  
  private func showError(_ error: Bool) {
    errorLabel.isHidden = !error
    reconnectButton.isHidden = !error
    nameAppImageView.isHidden = error
    error ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
  }
  
  @IBAction func reconnectButtonAction(_ sender: Any) {
    loadPuzzle()
  }
  
  @objc
  func setRootController() {
    guard
      let navigationController = MainViewController.instantiateInitialViewController() as? UINavigationController,
      let controller = navigationController.viewControllers.first as? MainViewController,
      let window = UIApplication.shared.keyWindow
    else { return }
  
    controller.applicationModel = applicationModel
    
    UIView.transition(with: window,
                      duration: durationTimer,
                      options: .transitionFlipFromLeft,
                      animations: {
                        window.rootViewController = navigationController
    }, completion: nil)

    window.makeKeyAndVisible()
  }
}
