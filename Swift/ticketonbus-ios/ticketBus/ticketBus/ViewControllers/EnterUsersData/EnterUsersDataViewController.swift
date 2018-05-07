//
//  EnterUsersDataViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 21.09.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SwiftyJSON

class EnterUsersDataViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Variables
  var currentRoute: ListOfRoutes?
  let flightsCellIdentifier = String(describing: FlightsTableViewCell.self)
  let userDataCellIdentifier = String(describing: UserDataTableViewCell.self)
  let authUserEnterDateIdentifier = String(describing: AuthUserEnterDateTableViewCell.self)
  
  var isOpenCells = [Bool]()
  var selectedSeats = [Int]()
  var dataInCells = [UserData]()
  var selectedIndexPath: IndexPath?
  var currentCode = "+7"
  var countryCode = "RU"
  let phoneNumberKit = PhoneNumberKit()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Ввод данных"
    
    for i in 0..<selectedSeats.count {
      var object = UserData()
      if i == 0 && User.isAuthorized {
        object = UserData(family: ConnectionManager.currentUser?.surname,
                          name: ConnectionManager.currentUser?.firstname,
                          part: ConnectionManager.currentUser?.patronymic,
                          placeBorn: nil,
                          dateBirth: ConnectionManager.currentUser?.date_of_birth,
                          sex: ConnectionManager.currentUser?.gender,
                          nationality: "РОССИЯ",
                          identification: "Паспорт РФ",
                          seriaAndNuber: nil,
                          phone: ConnectionManager.currentUser?.phone,
                          mainEmail: ConnectionManager.currentUser?.email,
                          confirmEmail: ConnectionManager.currentUser?.email)
      }
      
      dataInCells.append(object)
    }
    
    if let phone = dataInCells.first?.phone {
      if !phone.isEmpty {
        parseNumber(phone)
      }
    }
    
    setUpNavigationBar()
    
    tableView.tableFooterView = UIView()
    
    tableView.backgroundColor = UIColor.blueTicketBusTableColor
    
    tableView.register(UINib(nibName: flightsCellIdentifier, bundle: nil),
                       forCellReuseIdentifier: flightsCellIdentifier)
    tableView.register(UINib(nibName: userDataCellIdentifier, bundle: nil),
                       forCellReuseIdentifier: userDataCellIdentifier)
    tableView.register(UINib(nibName: authUserEnterDateIdentifier, bundle: nil),
                       forCellReuseIdentifier: authUserEnterDateIdentifier)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    removeTitleBackBarButtonItem()
    
    isOpenCells = Array(repeating: true, count: selectedSeats.count)
  }
  
  // MARK: - Methods
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
  
  func setUpNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Далее",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(nextStep(_:)))
  }
  
  func observerNotification(_ object: Any) {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(textFieldTextDidChange(_:)),
                                           name: NSNotification.Name.UITextFieldTextDidChange,
                                           object: object)
  }
  
  // MARK: - Actions
  @objc func clearFormButtonAction(_ sender: ATDynamicButton) {
    for object in dataInCells {
      object.family = nil
      object.name = nil
      object.part = nil
      object.placeBorn = nil
      object.dateBirth = nil
      object.seriaAndNuber =  nil
    }
    
    tableView.reloadData()
  }
  
  @objc func textFieldTextDidChange(_ notification: Notification) {
    guard
      let textField = notification.object as? UITextField,
      let currentText = textField.text
      else {
        return
    }
    
    if let cell = textField.superview?.superview?.superview?.superview as? UserDataTableViewCell {
      if let index = tableView.indexPath(for: cell) {
        switch textField {
        case cell.familyTextField:
          dataInCells[index.row].family = currentText
        case cell.nameTextField:
          dataInCells[index.row].name = currentText
        case cell.partTextField:
          dataInCells[index.row].part = currentText
        case cell.placeBornTextField:
          dataInCells[index.row].placeBorn = currentText
        case cell.seriaAndNuberTextField:
          dataInCells[index.row].seriaAndNuber = currentText
        case cell.phoneTextField:
          dataInCells[index.row].phone = currentText
        case cell.mainEmailTextField:
          dataInCells[index.row].mainEmail = currentText
        case cell.confirmEmailTextField:
          dataInCells[index.row].confirmEmail = currentText
        default:
          break
        }
      }
    }
    
    if let cell = textField.superview?.superview?.superview?.superview?.superview as? UserDataTableViewCell {
      if textField == cell.phoneTextField {
        if let index = tableView.indexPath(for: cell) {
          dataInCells[index.row].phone = currentText
        }
      }
    }
  }
  
  @objc func nextStep(_ sender: UIBarButtonItem) {
    var success = true
    
    for object in dataInCells {
      object.confirmEmail = dataInCells.first?.confirmEmail
      object.mainEmail = dataInCells.first?.mainEmail
      
      guard object.confirmEmail == object.mainEmail else {
        let alert = UIApplication.shared.showAlert("Email адреса не совпадают!", title: "")
        self.present(alert, animated: true, completion: nil)
        
        return
      }
      
      object.phone = dataInCells.first?.phone
      
      guard
        object.family != nil, object.name != nil, object.part != nil, object.placeBorn != nil,
        object.dateBirth != nil, object.sex != nil, object.nationality != nil, object.identification != nil,
        object.seriaAndNuber != nil, object.phone != nil, object.mainEmail != nil, object.confirmEmail != nil
      else {
        success = false
        break
      }
      
      guard
        !object.family!.isEmpty, !object.name!.isEmpty, !object.part!.isEmpty, !object.placeBorn!.isEmpty,
        !object.dateBirth!.isEmpty, !object.sex!.isEmpty, !object.nationality!.isEmpty, !object.identification!.isEmpty,
        !object.seriaAndNuber!.isEmpty, !object.phone!.isEmpty, !object.mainEmail!.isEmpty, !object.confirmEmail!.isEmpty
      else {
          success = false
          break
      }
      
      guard (object.seriaAndNuber! as NSString).range(of: " ").location != NSNotFound else {
        let alert = UIApplication.shared.showAlert("Введите правильную серию и номер документа!", title: "")
        self.present(alert, animated: true, completion: nil)
        
        return
      }
    }
    
    if success {
      if let controller = ViewEnterDatasViewController.viewController() as? ViewEnterDatasViewController {
        controller.currentRoute = self.currentRoute
        controller.dataInCells = self.dataInCells
        controller.selectedSeats = self.selectedSeats
        
        navigationController?.pushViewController(controller, animated: true)
      }
    } else {
      let alert = UIApplication.shared.showAlert("Пожалуйста, заполните все поля..", title: "")
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  @objc func tapDateTextFieldGesture(_ sender: UITapGestureRecognizer) {
    if let datePicker = DatePickerPopoverViewController.viewController() as? DatePickerPopoverViewController {
      let dateFormater = DateFormatter()
      dateFormater.dateFormat = "dd.MM.yyyy"
      
      if let cell = sender.view?.superview?.superview?.superview as? UserDataTableViewCell {
        if let index = tableView.indexPath(for: cell) {
          self.selectedIndexPath = index
        }
        
        if let date = cell.dateBirthTextField.text {
          datePicker.currentDate = dateFormater.date(from: date)
        }
      }
      
      datePicker.modalPresentationStyle = .popover
      datePicker.popoverPresentationController!.delegate = self
      datePicker.popoverPresentationController!.sourceView = sender.view
      datePicker.popoverPresentationController?.backgroundColor = UIColor.white
      datePicker.delegate = self
      
      present(datePicker, animated: true, completion: nil)
    }
  }
  
  @objc func tapNationalityTextFieldGesture(_ sender: UITapGestureRecognizer) {
    if let cell = sender.view?.superview?.superview?.superview as? UserDataTableViewCell {
      if let index = tableView.indexPath(for: cell) {
        self.selectedIndexPath = index
      }
    }
    
    if let controller = ListDocumentsViewController.viewController() as? ListDocumentsViewController {
      controller.isCountry = true
      controller.delegate = self
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  @objc func tapIdentificationTextFieldGesture(_ sender: UITapGestureRecognizer) {
    if let cell = sender.view?.superview?.superview?.superview as? UserDataTableViewCell {
      if let index = tableView.indexPath(for: cell) {
        self.selectedIndexPath = index
      }
    }
    
    if let controller = ListDocumentsViewController.viewController() as? ListDocumentsViewController {
      controller.isCountry = false
      controller.delegate = self
      navigationController?.pushViewController(controller, animated: true)
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
}

// MARK: - UITableViewDataSource
extension EnterUsersDataViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let countCellsInOneSection = User.isAuthorized ? 2 : 1
    return section == 0 ? countCellsInOneSection : selectedSeats.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: flightsCellIdentifier)
          as? FlightsTableViewCell else {
          return UITableViewCell()
        }
        
        cell.buyButton.isHidden = true
        cell.route = self.currentRoute
        cell.selectionStyle = .none
        
        cell.heightButtonConstraint.constant = 0.0
        cell.topButtonConstraint.constant = 8.0
        cell.layoutIfNeeded()
        
        return cell
      } else {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: authUserEnterDateIdentifier)
          as? AuthUserEnterDateTableViewCell else {
            return UITableViewCell()
        }
        
        cell.fullNameLabel.text = ConnectionManager.currentUser?.fullname
        cell.clearFormsButton.addTarget(self, action: #selector(clearFormButtonAction(_:)),
                                        for: .touchUpInside)
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.blueTicketBusTableColor
        
        return cell
      }
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: userDataCellIdentifier)
        as? UserDataTableViewCell else {
          return UITableViewCell()
      }
      
      cell.delegate = self
      
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDateTextFieldGesture(_:)))
      cell.dateStackView.addGestureRecognizer(tapGesture)

      let tapGestureNational = UITapGestureRecognizer(target: self, action: #selector(tapNationalityTextFieldGesture(_:)))
      cell.nationalityStackView.addGestureRecognizer(tapGestureNational)
      
      let tapGestureIdentif = UITapGestureRecognizer(target: self, action: #selector(tapIdentificationTextFieldGesture(_:)))
      cell.identificationStackView.addGestureRecognizer(tapGestureIdentif)
      
      cell.familyTextField.text = dataInCells[indexPath.row].family
      cell.nameTextField.text = dataInCells[indexPath.row].name
      cell.partTextField.text = dataInCells[indexPath.row].part
      cell.placeBornTextField.text = dataInCells[indexPath.row].placeBorn
      cell.dateBirthTextField.text = dataInCells[indexPath.row].dateBirth
      cell.nationalityTextField.text = dataInCells[indexPath.row].nationality
      cell.identificationTextField.text = dataInCells[indexPath.row].identification
      cell.seriaAndNuberTextField.text = dataInCells[indexPath.row].seriaAndNuber
      cell.phoneTextField.text = dataInCells[indexPath.row].phone
      cell.mainEmailTextField.text = dataInCells[indexPath.row].mainEmail
      cell.confirmEmailTextField.text = dataInCells[indexPath.row].confirmEmail
      
      if let image = UIImage(named: countryCode) {
        cell.countryImage.image = image
      }
      
      observerNotification(cell.familyTextField)
      observerNotification(cell.nameTextField)
      observerNotification(cell.partTextField)
      observerNotification(cell.placeBornTextField)
      observerNotification(cell.seriaAndNuberTextField)
      observerNotification(cell.phoneTextField)
      observerNotification(cell.mainEmailTextField)
      observerNotification(cell.confirmEmailTextField)
    
      let tapPhoneGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhoneGesture(_:)))
      cell.phoneStack.gestureRecognizers?.removeAll()
      cell.phoneStack.addGestureRecognizer(tapPhoneGesture)
      
      cell.familyTextField.delegate = self
      cell.nameTextField.delegate = self
      cell.partTextField.delegate = self
      cell.seriaAndNuberTextField.delegate = self
      cell.phoneTextField.delegate = self
      cell.mainEmailTextField.delegate = self
      cell.confirmEmailTextField.delegate = self
      
      cell.phoneStack.isHidden = indexPath.row != 0
      cell.emailStack.isHidden = indexPath.row != 0
      cell.confirmEmailStack.isHidden = indexPath.row != 0
      
      if let gender = dataInCells[indexPath.row].sex {
        if let button = cell.sexButtons.first(where: { (object) -> Bool in
          return gender == "male" ? object.tag == 0 : object.tag == 1
        }) {
          button.setImage(#imageLiteral(resourceName: "radio_active"), for: .normal)
          
          for object in cell.sexButtons {
            guard object.tag != button.tag else {
              continue
            }
            
            object.setImage(#imageLiteral(resourceName: "radio_unactive"), for: .normal)
          }
        }
      }
      
      cell.contView.isHidden = !isOpenCells[indexPath.row]
      let rotate = !isOpenCells[indexPath.row] ? CGFloat(Double.pi) : CGFloat(Double.pi * 2)
      cell.arrowImageView.transform = CGAffineTransform(rotationAngle: rotate)
      
      cell.numberOfSeatsLabel.text = "Место №\(selectedSeats[indexPath.row])"
      cell.selectionStyle = .none
      
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }
}

// MARK: - UITableViewDelegate
extension EnterUsersDataViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if indexPath.section != 0 {
      isOpenCells[indexPath.row] = !isOpenCells[indexPath.row]

      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPath], with: .automatic)
      tableView.endUpdates()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 12.0
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return UITableViewAutomaticDimension
    }
    
    let height: CGFloat = indexPath.row == 0 ? 600.0 : 456.0
    return isOpenCells[indexPath.row] ? height : 44.0
  }
}

// MARK: - DatePickerPopoverDelegate
extension EnterUsersDataViewController: DatePickerPopoverDelegate {
  func datePicker(didFinishPicking date: Date) {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "dd.MM.yyyy"

    if selectedIndexPath != nil {
      self.dataInCells[selectedIndexPath!.row].dateBirth = dateFormater.string(from: date)
      
      tableView.beginUpdates()
      tableView.reloadRows(at: [selectedIndexPath!], with: .automatic)
      tableView.endUpdates()
    }
  }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension EnterUsersDataViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}

// MARK: - ListDocumentsViewControllerDelegate
extension EnterUsersDataViewController: ListDocumentsViewControllerDelegate {
  func getCountry(_ newObject: String, isCountry: Bool) {
    if selectedIndexPath != nil {
      if isCountry {
        self.dataInCells[selectedIndexPath!.row].nationality = newObject
      } else {
        self.dataInCells[selectedIndexPath!.row].identification = newObject
      }
      
      tableView.beginUpdates()
      tableView.reloadRows(at: [selectedIndexPath!], with: .automatic)
      tableView.endUpdates()
    }
  }
}

// MARK: - ListDocumentsViewControllerDelegate
extension EnterUsersDataViewController: UserDataTableViewCellDelegate {
  func newSex(_ tag: Int, cell: UITableViewCell) {
    if let index = tableView.indexPath(for: cell) {
      let sex = tag == 0 ? "male" : "female"
      self.dataInCells[index.row].sex = sex
    }
  }
}

// MARK: - UITextFieldDelegate
extension EnterUsersDataViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let cell = textField.superview?.superview?.superview?.superview?.superview as? UserDataTableViewCell {
      if textField == cell.phoneTextField {
        if string == "" {
          if textField.text == currentCode {
            return false
          }
        }
      }
    }
    
    if let cell = textField.superview?.superview?.superview?.superview as? UserDataTableViewCell {
      if textField != cell.seriaAndNuberTextField {
        if string == " " {
          return false
        }
      } else {
        if let text = textField.text {
          if (text as NSString).range(of: " ").location != NSNotFound && string == " " {
            return false
          }
        }
      }
    }
    
    return true
  }
}

// MARK: - PhonePickerPopoverDelegate
extension EnterUsersDataViewController: PhonePickerPopoverDelegate {
  func phonePicker(didFinishPicking countryCode: String, phoneCode: String, flag: UIImage) {
    if let phone = dataInCells[0].phone {
      dataInCells[0].phone = phone.replacingOccurrences(of: currentCode, with: phoneCode)
    }
    
    currentCode = phoneCode
    self.countryCode = countryCode
    
    for cell in self.tableView.visibleCells {
      if cell.isKind(of: UserDataTableViewCell.self) {
        (cell as! UserDataTableViewCell).countryImage.image = flag
        break
      }
    }
    
    tableView.reloadData()
  }
}
