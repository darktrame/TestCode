//
//  ProScreenViewController.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 27.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit
import StoreKit
import CoreData

protocol ProScreenViewControllerDelegate {
  func reloadTableView()
}

class ProScreenViewController: UIViewController {
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var loadingView: UIVisualEffectView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  private var allProducts = [SKProduct]()
  private var timer: Timer?
  private var restore = false
  
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
  
  func hideLoading() {
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()
      UIView.animate(withDuration: 0.3, animations: {
        self.loadingView.alpha = 0.0
      })
    }
  }
  
  func showErrorAlert(_ message: String) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .cancel) { (action) in
      self.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(ok)
    self.present(alert, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if UIScreen.main.bounds.size.height == 568.0 {
      topConstraint.constant = 8.0
      view.layoutIfNeeded()
    }
    
    activityIndicator.startAnimating()
    RageProducts.store.requestProducts{ (success, products) in
      if let products = products {
        self.allProducts = products
        self.hideLoading()
      } else {
        DispatchQueue.main.async {
          self.showErrorAlert("iTunes Store error...")
        }
      }
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
                                           name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleRestoreNotification(_:)),
                                           name: NSNotification.Name(rawValue: IAPHelper.IAPHelperRestoreNotification),
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(errorNotification(_:)),
                                           name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseFailedNotification),
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
    NotificationCenter.default.removeObserver(self,
                                              name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseFailedNotification),
                                              object: nil)
  }
  
  @objc
  private func errorNotification(_ notification: Notification) {
    guard let message = notification.userInfo?["message"] as? String else { return }
    showErrorAlert(message)
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
    RageProducts.store.getAppReceipt(completion: {
      DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if let respond = self.delegate?.reloadTableView() { respond }
        self.dismiss(animated: true, completion: nil)
      }
    })
  }
  
  @objc
  func handleRestoreNotification(_ notification: Notification) {
    RageProducts.store.getAppReceipt(completion: {
      DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if !self.restore {
          self.restore = true
          self.scheduleRestoreSuccessfullAlert()
        }
      }
    })
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
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    RageProducts.store.buyProduct(allProducts.first!)
  }
  
  @IBAction func restorePurchasesButtonAction(_ sender: UIButton) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    RageProducts.store.restorePurchases()
  }
}
