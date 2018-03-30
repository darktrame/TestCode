//
//  ProScreenViewController.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 27.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit
import StoreKit

protocol ProScreenViewControllerDelegate {
  func reloadTableView()
}

class ProScreenViewController: UIViewController {
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  @IBOutlet weak var closeButton: UIButton!
  
  private var allProducts = [SKProduct]()
  private var timer: Timer?
  
  var delegate: ProScreenViewControllerDelegate?
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.isHidden = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = true
    UIView.animate(withDuration: 0.5, delay: 3.0, options: [.allowUserInteraction], animations: {
      self.closeButton.alpha = 1.0
    }, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if UIScreen.main.bounds.size.height == 568.0 {
      topConstraint.constant = 8.0
      view.layoutIfNeeded()
    }
    
    RageProducts.store.requestProducts{ (success, products) in
      if let products = products {
        self.allProducts = products
      }
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
                                           name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleRestoreNotification(_:)),
                                           name: NSNotification.Name(rawValue: IAPHelper.IAPHelperRestoreNotification),
                                           object: nil)
    
    removeTitleBackBarButtonItem()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self,
                                              name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                              object: nil)
    NotificationCenter.default.removeObserver(self,
                                              name: NSNotification.Name(rawValue: IAPHelper.IAPHelperRestoreNotification),
                                              object: nil)
  }
  
  @objc
  private func showRestoreSuccessfullAlert() {
    let alert = UIAlertController(title: "",
                                  message: NSLocalizedString("purchaseRestored", comment: ""), preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
      if let respond = self.delegate?.reloadTableView() { respond }
      self.dismiss(animated: true, completion: nil)
    }))
    
    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
  }
  
  func scheduleRestoreSuccessfullAlert() {
    timer?.invalidate()
    
    timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(showRestoreSuccessfullAlert),
                                 userInfo: nil, repeats: false)
  }
  
  @objc
  func handlePurchaseNotification(_ notification: Notification) {
    User.isPremiumVersionActive = true
    if let respond = self.delegate?.reloadTableView() { respond }
    dismiss(animated: true, completion: nil)
  }
  
  @objc
  func handleRestoreNotification(_ notification: Notification) {
    scheduleRestoreSuccessfullAlert()
    User.isPremiumVersionActive = true
  }
  
  @IBAction func closeButtonAction(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func presentFileButtonAction(_ sender: ATButton) {
    guard let controller = WebViewController.instantiateInitialViewController() as? WebViewController else { return }
    controller.content = sender.tag == 0 ? .termsOfUse : .privacyPolicy
    navigationController?.pushViewController(controller, animated: true)
  }
  
  @IBAction func buy(_ sender: UIButton) {
    guard allProducts.first != nil else { return }
    RageProducts.store.buyProduct(allProducts.first!)
  }
  
  @IBAction func restorePurchasesButtonAction(_ sender: UIButton) {
    RageProducts.store.restorePurchases()
  }
}
