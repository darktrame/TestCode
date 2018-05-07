//
//  ContactsViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 04.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class ContactsViewController: GlobalViewController {
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Outlets
  let titlesSecions = ["АДРЕС АВТОСТАНЦИИ", "ТЕЛЕФОНЫ АВТОСТАНЦИИ", "ЧАСЫ РАБОТЫ АВТОСТАНЦИИ"]
  let adressStationIdentifier = String(describing: AdressStationTableViewCell.self)
  let shemeIdentifier = String(describing: ShemeTableViewCell.self)
  let numberIdentifier = String(describing: NumberPhoneTableViewCell.self)
  
  let numbersArray = ["+7 (967) 079-87-24",
                      "+7 (926) 917-34-74",
                      "+7 (495) 426-87-51",
                      "+7 (967) 057-13-42",
                      "+7 (495) 589-61-47",
                      "+7 (968) 897-35-28"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Контакты"
    
    tableView.backgroundColor = UIColor.blueTicketBusTableColor
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44.0
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.tableFooterView = UIView()
    
    tableView.register(UINib(nibName: adressStationIdentifier, bundle: nil),
                       forCellReuseIdentifier: adressStationIdentifier)
    tableView.register(UINib(nibName: shemeIdentifier, bundle: nil),
                       forCellReuseIdentifier: shemeIdentifier)
    tableView.register(UINib(nibName: numberIdentifier, bundle: nil),
                       forCellReuseIdentifier: numberIdentifier)
    
    removeTitleBackBarButtonItem()
  }
}

// MARK: - UITableViewDataSource
extension ContactsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = .clear
    
    let headerLabel = UILabel(frame: CGRect(x: 16, y: section == 0 ? 20.0 : 0,
                                            width: tableView.bounds.size.width,
                                            height: tableView.bounds.size.height))
    headerLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 12)
    headerLabel.textColor = UIColor(red: 119.0 / 255.0,
                                    green: 160.0 / 255.0,
                                    blue: 186.0 / 255.0,
                                    alpha: 1.0)
    headerLabel.text = titlesSecions[section]
    headerLabel.sizeToFit()
    headerView.addSubview(headerLabel)
    
    return headerView
  }
  

  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 2
    case 1:
      return 6
    case 2:
      return 1
    default:
      return 0
    }
  }
  
  func getCellFrom(identifier ident: String) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ident) else {
      return UITableViewCell()
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 {
        let cell = getCellFrom(identifier: adressStationIdentifier)
        cell.selectionStyle = .none
        
        return cell
      } else {
        let cell = getCellFrom(identifier: shemeIdentifier)
        
        return cell
      }
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: numberIdentifier)
        as? NumberPhoneTableViewCell else {
        return UITableViewCell()
      }
      
      cell.numberLabel.text = numbersArray[indexPath.row]
      cell.phoneImageView.image = cell.phoneImageView.image?.withRenderingMode(.alwaysTemplate)
      cell.phoneImageView.tintColor = .orange
      
      return cell
    default:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "timeWork") else {
        return UITableViewCell()
      }
      
      cell.selectionStyle = .none
      
      return cell
    }
  }
}

// MARK: - UITableViewDelegate
extension ContactsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 40.0
    }
    
    return 20.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if indexPath.row == 1 && indexPath.section == 0 {
      if let controller = MapViewController.viewController() {
        navigationController?.pushViewController(controller, animated: true)
      }
    }
    
    if indexPath.section == 1 {
      var stringNumber = numbersArray[indexPath.row].replacingOccurrences(of: "-", with: "")
      stringNumber = stringNumber.replacingOccurrences(of: " ", with: "")
      stringNumber = stringNumber.replacingOccurrences(of: "(", with: "")
      stringNumber = stringNumber.replacingOccurrences(of: ")", with: "")
      
      guard let number = URL(string: "tel://" + stringNumber) else {
        return
      }
      
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(number)
      } else {
        UIApplication.shared.openURL(number)
      }
    }
  }
}
