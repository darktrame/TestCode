//
//  ForgotPasswordViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 21.08.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var emailTextField: ATTextField!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.loadingView.alpha = 0.0
    
    title = "Восстановление пароля"
    
    view.backgroundColor = .blueTicketBusLightColor
    
    emailTextField.delegate = self
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
      self.loadingView.alpha = 0.5
    }
    
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
  }
  
  // MARK: - Actions
  @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
    showLoadingView()
    
    guard
      let userName = emailTextField.text
    else {
      hiddeLoadingView()
        
      return
    }
    
    guard !userName.isEmpty else {
      hiddeLoadingView()
      
      let alert = UIApplication.shared.showAlert("Введите E-mail и повторите попытку!", title: "")
      self.present(alert, animated: true, completion: nil)
      
      return
    }
    
    hiddeLoadingView()
    
    // MARK: - TODO
  }
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.isFirstResponder {
      textField.resignFirstResponder()
    }
    
    return true
  }
}
