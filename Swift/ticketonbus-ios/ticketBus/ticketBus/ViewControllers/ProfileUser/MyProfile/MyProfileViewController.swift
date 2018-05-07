//
//  MyProfileViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 04.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SwiftyJSON

protocol MyProfileViewControllerDelegate {
  func deleteUser()
}

class MyProfileViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var familyTextField: ATTextField!
  @IBOutlet weak var nameTextField: ATTextField!
  @IBOutlet weak var partronymicTextField: ATTextField!
  @IBOutlet weak var dateTextField: ATTextField!
  @IBOutlet weak var phoneTextField: ATTextField!
  @IBOutlet weak var emailTextField: ATTextField!
  
  @IBOutlet weak var dateStackView: UIStackView!
  @IBOutlet weak var phoneStackView: UIStackView!
  
  @IBOutlet weak var countryImage: UIImageView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var heightButtonConstraint: NSLayoutConstraint!
  
  // MARK: - Variables
  var currentProfile: Profile?
  var delegate: MyProfileViewControllerDelegate?
  let phoneNumberKit = PhoneNumberKit()
  var currentCode = "+7"
  var countryCode = "RU"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadingView.backgroundColor = UIColor.blueTicketBusTableColor
    
    showLoadingView()
    setObserver()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDateTextFieldGesture(_:)))
    dateStackView.addGestureRecognizer(tapGesture)
    
    ConnectionManager.share.getGetUser { (result, error) in
      if let profile = result {
        self.currentProfile = profile
        
        DispatchQueue.main.async {
          self.setNewDataUser()
          self.hideLoadingView()
        }
      }
    }
    
    let tapGesturePhone = UITapGestureRecognizer(target: self, action: #selector(tapPhoneGesture(_:)))
    phoneStackView.addGestureRecognizer(tapGesturePhone)
    
    let heightScreen = UIScreen.main.bounds.size.height
    
    if heightScreen < 568.0 {
      heightButtonConstraint.constant = 20.0
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    removeObserver()
  }
  
  // MARK: - Methods
  func setObserver() {
    familyTextField.delegate = self
    nameTextField.delegate = self
    partronymicTextField.delegate = self
    phoneTextField.delegate = self
    emailTextField.delegate = self
    
    observerNotification(familyTextField)
    observerNotification(nameTextField)
    observerNotification(partronymicTextField)
    observerNotification(phoneTextField)
    observerNotification(emailTextField)
  }
  
  func removeObserver() {
    removeObserverNotification(familyTextField)
    removeObserverNotification(nameTextField)
    removeObserverNotification(partronymicTextField)
    removeObserverNotification(phoneTextField)
    removeObserverNotification(emailTextField)
  }
  
  func observerNotification(_ object: Any) {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(textFieldTextDidChange(_:)),
                                           name: NSNotification.Name.UITextFieldTextDidChange,
                                           object: object)
  }

  func removeObserverNotification(_ object: Any) {
    NotificationCenter.default.removeObserver(self,
                                              name: NSNotification.Name.UITextFieldTextDidChange,
                                              object: object)
  }
    
  func showLoadingView() {
    activityIndicator.startAnimating()
    
    UIView.animate(withDuration: 0.3) {
      self.loadingView.alpha = 1.0
    }
  }
  
  func hideLoadingView() {
    activityIndicator.stopAnimating()
    
    UIView.animate(withDuration: 0.3) {
      self.loadingView.alpha = 0.0
    }
  }
  
  func setNewDataUser() {
    familyTextField.text = self.currentProfile?.surname
    nameTextField.text = self.currentProfile?.firstname
    partronymicTextField.text = self.currentProfile?.patronymic
    dateTextField.text = self.currentProfile?.date_of_birth
    phoneTextField.text = self.currentProfile?.phone
    emailTextField.text = self.currentProfile?.email
    
    parseNumber(self.currentProfile!.phone!)
    
    countryImage.image = UIImage(named: self.countryCode)
  }
  
  func parseNumber(_ number: String) {
    if let path = Bundle.main.path(forResource: "countryCodes", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = JSON(data: data)
        
        if let array = jsonResult.array {
          for object in array {
            guard let dial_code = object["dial_code"].string, let code = object["code"].string else {
              continue
            }
            
            do {
              let phoneNumber = try phoneNumberKit.parse(number, withRegion: code, ignoreType: true)
              
              let currentCodeUser = "+\(String(phoneNumber.countryCode))"
              
              if dial_code == currentCodeUser {
                self.currentCode = currentCodeUser
                self.countryCode = code
                break
              }
            }
            catch {
              print("Something went wrong")
            }
          }
        }
      } catch {
        // handle error
      }
    }
  }
  
  // MARK: - Actions
  @IBAction func saveButtonAction(_ sender: UIButton) {
    if let profile = self.currentProfile {
      self.showLoadingView()
      ConnectionManager.share.updateUser(profile, { (result, error) in
        if let profile = result {
          self.currentProfile = profile
          
          DispatchQueue.main.async {
            self.setNewDataUser()
            self.hideLoadingView()
          }
        }
      })
    }
  }
  
  @objc func tapPhoneGesture(_ sender: UITapGestureRecognizer) {
    if let country = PhonePickerPopoverViewController.viewController() as? PhonePickerPopoverViewController {
      country.modalPresentationStyle = .popover
      country.popoverPresentationController!.delegate = self
      country.popoverPresentationController!.sourceView = sender.view
      country.popoverPresentationController?.backgroundColor = UIColor.white
      country.currentCode = self.countryCode
      country.delegate = self
      
      present(country, animated: true, completion: nil)
    }
  }
  
  @IBAction func removeAccountButtonAction(_ sender: UIButton) {
    let alert = UIAlertController(title: "",
                                  message: "Вы действительно хотите удалить профиль?",
                                  preferredStyle: .alert)
    
    let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
    let confirm = UIAlertAction(title: "Удалить", style: .default) { (action) in
      // TODO
      if let respond = self.delegate?.deleteUser() {
        respond
      }
    }
    
    alert.addAction(cancel)
    alert.addAction(confirm)
    
    present(alert, animated: true, completion: nil)
  }
  
  @objc func tapDateTextFieldGesture(_ sender: UITapGestureRecognizer) {
    if let datePicker = DatePickerPopoverViewController.viewController() as? DatePickerPopoverViewController {
      let dateFormater = DateFormatter()
      dateFormater.dateFormat = "dd.MM.yyyy"
      
      if let dateString = self.currentProfile?.date_of_birth {
        datePicker.currentDate = dateFormater.date(from: dateString)
      }
      
      datePicker.modalPresentationStyle = .popover
      datePicker.popoverPresentationController!.delegate = self
      datePicker.popoverPresentationController!.sourceView = dateTextField
      datePicker.popoverPresentationController?.backgroundColor = UIColor.white
      datePicker.delegate = self
      
      present(datePicker, animated: true, completion: nil)
    }
  }
  
  @objc func textFieldTextDidChange(_ notification: Notification) {
    guard let textField = notification.object as? ATTextField else {
      return
    }
    
    switch textField {
    case familyTextField:
      self.currentProfile?.surname = textField.text
    case nameTextField:
      self.currentProfile?.firstname = textField.text
    case partronymicTextField:
      self.currentProfile?.patronymic = textField.text
    case phoneTextField:
      self.currentProfile?.phone = textField.text
    case emailTextField:
      self.currentProfile?.email = textField.text
    default:
      break
    }
  }
}

// MARK: - UITextFieldDelegate
extension MyProfileViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == phoneTextField {
      if string == "" {
        if textField.text == currentCode {
          return false
        }
      }
    }
    
    if string == " " {
      return false
    }
    
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case familyTextField:
      nameTextField.becomeFirstResponder()
    case nameTextField:
      partronymicTextField.becomeFirstResponder()
    case partronymicTextField:
      phoneTextField.becomeFirstResponder()
    case phoneTextField:
      emailTextField.becomeFirstResponder()
    case emailTextField:
      emailTextField.resignFirstResponder()
    default:
      break
    }
    
    return true
  }
}

// MARK: - DatePickerPopoverDelegate
extension MyProfileViewController: DatePickerPopoverDelegate {
  func datePicker(didFinishPicking date: Date) {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "dd.MM.yyyy"
    
    self.currentProfile?.date_of_birth = dateFormater.string(from: date)
    dateTextField.text = dateFormater.string(from: date)
  }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension MyProfileViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}

// MARK: - PhonePickerPopoverDelegate
extension MyProfileViewController: PhonePickerPopoverDelegate {
  func phonePicker(didFinishPicking countryCode: String, phoneCode: String, flag: UIImage) {
    if let phone = phoneTextField.text {
      phoneTextField.text = phone.replacingOccurrences(of: currentCode, with: phoneCode)
      self.currentProfile?.phone = phoneTextField.text
    }
    
    self.currentCode = phoneCode
    self.countryCode = countryCode
    
    countryImage.image = UIImage(named: self.countryCode)
  }
}
