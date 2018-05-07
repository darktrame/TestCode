//
//  ConfirmSMSViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 06.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class ConfirmSMSViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var pinTextField: ATTextField!
  @IBOutlet weak var loadingImage: UIImageView!
  @IBOutlet weak var visualEffectView: UIVisualEffectView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Variables
  var selectedSeats = [Int]()
  var dataInCells = [UserData]()
  var insurance = [Int]()
  var currentRoute: ListOfRoutes?
  var email = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadingView.alpha = 0.0
    loadingView.backgroundColor = UIColor.blueTicketBusTableColor
    
    self.visualEffectView.alpha = 0.0
    
    title = "Оплата"
    
    view.backgroundColor = UIColor.blueTicketBusTableColor
    
    pinTextField.textAlignment = .center
    
    removeTitleBackBarButtonItem()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    startAnimation()
    
    self.perform(#selector(stopAnimation), with: self, afterDelay: 3.0)
  }
  
  // MARK: - Methods
  func hiddeLoadingView() {
    activityIndicator.stopAnimating()
    activityIndicator.isHidden = true
    
    UIView.animate(withDuration: 0.3) {
      self.loadingView.alpha = 0.0
    }
  }
  
  func showLoadingView() {
    UIView.animate(withDuration: 0.3) {
      self.loadingView.alpha = 1.0
    }
    
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
  }
  
  func sendNewOrder() {
    ConnectionManager.share.newOrder(self.selectedSeats,
                                     dataInCells: self.dataInCells,
                                     insurance: self.insurance,
                                     currentRoute: self.currentRoute,
                                     completion: { (result, error) in
                                      DispatchQueue.main.async {
                                        if let order = result {
                                          self.hiddeLoadingView()
                                          
                                          if let controller = PayViewController.viewController() as? PayViewController {
                                            controller.link = order.link
                                            controller.cost = order.amount
                                            
                                            self.navigationController?.pushViewController(controller, animated: true)
                                          }
                                        } else {
                                          self.hiddeLoadingView()
                                          let alert = UIApplication.shared.showAlert(error ?? "Произошла ошибка, попробуйте позже!", title: "")
                                          self.present(alert, animated: true, completion: nil)
                                        }
                                      }
    })
  }
  
  func startAnimation() {
    UIView.animate(withDuration: 0.3) {
      self.visualEffectView.alpha = 1.0
    }
    
    let animation = CABasicAnimation(keyPath: "transform")
    animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
    
    animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(Double.pi / 2.0), 0.0, 0.0, 1.0))
    animation.duration = 0.3
    animation.isCumulative = true
    animation.repeatCount = MAXFLOAT
    
    self.loadingImage.layer.add(animation, forKey: "loading")
    self.loadingImage.startAnimating()
  }
  
  // MARK: - Actions
  @objc func stopAnimation() {
    self.loadingImage.stopAnimating()
    
    UIView.animate(withDuration: 0.3) {
      self.visualEffectView.alpha = 0.0
    }
  }
  
  @IBAction func enterButtonAction(_ sender: UIButton) {
    showLoadingView()
    
    if let pincodeString = pinTextField.text {
      if let pincode = Int(pincodeString) {
        ConnectionManager.share.authUser(email, pincode: pincode) { (object, error) in
          DispatchQueue.main.async {
            if error == nil {
              if let userData = object {
                User.username = userData.username
                User.user_id = userData.user_id
                User.user_token = userData.user_token
                
                User.isAuthorized = true
                
                self.sendNewOrder()
              } else {
                self.hiddeLoadingView()
                let alert = UIApplication.shared.showAlert("Ошибка сервера", title: "")
                self.present(alert, animated: true, completion: nil)
              }
            } else {
              let alert = UIApplication.shared.showAlert(error!, title: "")
              self.present(alert, animated: true, completion: nil)
            }
          }
        }
      } else {
        self.hiddeLoadingView()
        let alert = UIApplication.shared.showAlert("Введите корректный пин-код", title: "")
        self.present(alert, animated: true, completion: nil)
      }
    } else {
      self.hiddeLoadingView()
      let alert = UIApplication.shared.showAlert("Введите корректный пин-код", title: "")
      self.present(alert, animated: true, completion: nil)
    }
  }
}
