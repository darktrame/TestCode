//
//  AuthViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 21.08.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class AuthViewController: GlobalViewController {
  // MARK: - Outlets
  @IBOutlet weak var emailTextField: ATTextField!
  @IBOutlet weak var passwordTextField: ATTextField!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var height: NSLayoutConstraint!
  @IBOutlet weak var width: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadingView.alpha = 0.0
    loadingView.backgroundColor = UIColor.blueTicketBusTableColor
    
    view.backgroundColor = .blueTicketBusLightColor
    
    title = "Авторизация"
    
    removeTitleBackBarButtonItem()
    
    emailTextField.delegate = self
    passwordTextField.delegate = self
    
    let heightScreen = UIScreen.main.bounds.size.height
    
    if heightScreen < 568.0 {
      self.height.constant = 100.0
      self.width.constant = 150.0
    }
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
  @IBAction func forgotPasswordButtonAction(_ sender: Any) {
    if let controller = WebViewController.viewController() as? WebViewController {
      controller.link = "https://ticketonbus.ru/user/password-reminder"
      controller.titleString = "Восстановление пароля"
      
      navigationController?.pushViewController(controller, animated: true)
    }
//    if let controller = ForgotPasswordViewController.viewController() {
//      navigationController?.pushViewController(controller, animated: true)
//    }
  }
  
  @IBAction func enterButtonAction(_ sender: UIButton) {
    showLoadingView()
    
    guard
      let userName = emailTextField.text,
      let password = passwordTextField.text
    else {
      hiddeLoadingView()
      
      return
    }
    
    guard !userName.isEmpty, !password.isEmpty else {
      hiddeLoadingView()
      
      let alert = UIApplication.shared.showAlert("Введите все данные и повторите попытку!", title: "")
      self.present(alert, animated: true, completion: nil)
      
      return
    }
    
    ConnectionManager.share.authUser(userName, password: password) { (result, error) in
      if let userData = result {
        User.username = userData.username
        User.user_id = userData.user_id
        User.user_token = userData.user_token
        
        User.isAuthorized = true
        
        DispatchQueue.main.async {
          self.hiddeLoadingView()
          
          if let controller = ProfileUserViewController.viewController() {
            self.navigationController?.setViewControllers([controller], animated: true)
          }
        }
        
      } else {
        self.hiddeLoadingView()
        
        if error != nil {
          let alert = UIApplication.shared.showAlert(error!, title: "")
          self.present(alert, animated: true, completion: nil)
        } else {
          let alert = UIApplication.shared.showAlert("Проверьте интернет соединение и поврорите попытку.", title: "")
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.isFirstResponder {
      if textField == emailTextField {
        textField.resignFirstResponder()
        
        passwordTextField.becomeFirstResponder()
      } else {
        passwordTextField.resignFirstResponder()
      }
    }
    
    return true
  }
}
